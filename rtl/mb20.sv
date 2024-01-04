// TODO: Should the lack ACKN pulse last until START releases? (For
// back-to-back cycles on the same phase I don't know that it will
// actually release.)
`include "kl10pv.svh"

// This module pretends to be a MB20 core memory. The A phase is
// negedge of mbus.clk and B phase is posedge.
//
// TODO:
//
// * Implement write cycles.
//
// * Implement read-pause-write cycles.
//
// * Implement BLKO PI diagnostic cycle support.
//
// * Support interleaving.
//
// * Support ACKN of next word while VALID on current word
//
// * This design will not properly handle case of inRq with
//   discontiguous bits. This needs fixing!

module mb20 #(parameter MEMSIZE=512*1024) (iMBUS.memory mbus);
  W36 mem[] = new[MEMSIZE];
  bit aClk, bClk;
  W36 aData, bData;
  bit aParity, bParity;
  tMemAddr addr;
  int dumpFD = feSim.dumpFD;

  always_comb aClk = ~mbus.clk;
  always_comb bClk =  mbus.clk;

  // This handles muxing the D bus and its parity for A/B.
  always_comb begin
    mbus.dIn = mbus.validInA ? aData : mbus.validInB ? bData : 0;
    mbus.parIn = aClk ? aParity : bParity;
  end

  always_latch if (mbus.adrHold) addr = mbus.adr;

  always @(posedge mbus.startA, posedge mbus.startB) begin
    if (dumpFD != 0) $fdisplay(dumpFD, "%7g ----> MB20 READ mem[%1o]=%s",
			       $realtime, mbus.adr, feSim.fmt36(mem[mbus.adr]));
  end

  mb20Phase aPhase(.clk(aClk),
		   .reset(mbus.memReset),
		   .start(mbus.startA),
		   .ackn(mbus.acknA),
		   .validIn(mbus.validInA),
		   .validOut(mbus.validOutA),
		   .inRq(mbus.rq),
		   .d(aData),
		   .parity(aParity),
		   .diag(mbus.diag),
		   .*);
  mb20Phase bPhase(.clk(bClk),
		   .reset(mbus.memReset),
		   .start(mbus.startB),
		   .ackn(mbus.acknB),
		   .validIn(mbus.validInB),
		   .validOut(mbus.validOutB),
		   .inRq(mbus.rq),
		   .d(bData),
		   .parity(bParity),
		   .diag(mbus.diag),
		   .*);
endmodule


// This is one phase of the MB20 core memory. For now, we implement
// only read cycles and only non-interleaved organization.
//
// NOTE: START may already be asserted for subsequent cycle while we
// are still finishing up the VALID pulses for the current one?
module mb20Phase (input bit clk,
		  input bit reset,
		  input tMemAddr addr,
		  input bit [0:3] inRq,
		  output bit validIn,
		  input bit validOut,
		  output W36 d,
		  output bit parity,
		  input bit start,
		  input bit diag,
		  output bit ackn);

  typedef bit [0:1] tQuadAddr;

  tMemAddr curAddr = 0;	      // Word we are currently reading/writing
  tMemAddr nextAddr = 0;      // Word we read/write next
  tQuadAddr wo = 0;	      // Word offset of quadword
  bit [0:3] toAck;	      // Words we have not yet ACKed
  W36 word;		      // Word we are returning this cycle

  always_ff @(posedge clk) begin
    string words[$] = feSim.split($sformatf("%m"), ".");
    string phase = words[3];	// XXX HaxRUs
    int dumpFD = feSim.dumpFD;

    if (diag) begin
      if (dumpFD != 0) $fdisplay(dumpFD, "%7g ----> %m DIAG", $realtime);
    end

    if (!start) begin		// Whenever we are not busy we're reset
      toAck <= 0;
      validIn <= 0;
      ackn <= 0;
      curAddr <= 0;
      nextAddr <= 0;
      wo <= 0;
      word <= 36'o123456_654321;
    end else begin

      if (toAck == 0) begin     // A transfer is starting.
	tQuadAddr startWO = addr[34:35];
	curAddr <= addr;		// Address of first word we do.
	nextAddr <= {addr[14:33], startWO + 2'o1};
	wo <= startWO;		// Word offset we increment mod 4.
	word <= memory0.mem[addr];
	toAck <= inRq << 1;	// Addresses after this one that are remaining to ACK.
	validIn <= 1;		// Already presenting valid data.
	ackn <= 1;		// ACK this address.
	if (dumpFD != 0) $fdisplay(dumpFD, "%7g ----> %s mem[%o]=%s (inRq=%b)", $realtime, phase,
				   addr, feSim.fmt36(memory0.mem[addr]), inRq);
      end else begin
	if (dumpFD != 0) $fdisplay(dumpFD, "%7g ----> %s mem[%o]=%s (toAck=%b)", $realtime, phase,
				   curAddr, feSim.fmt36(memory0.mem[curAddr]), toAck);
	word <= memory0.mem[curAddr];
	curAddr <= nextAddr;
	nextAddr <= {curAddr[14:33], wo + 2'o1};
	ackn <= 1;
	validIn <= 1;
	wo <= wo + 1;
	toAck <= toAck << 1;
      end
  end

  always_comb begin
    d = word;
    parity = !^d;
  end
endmodule
