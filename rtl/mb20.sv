// TODO: Should the lack ACKN pulse last until START releases? (For
// back-to-back cycles on the same phase I don't know that it will
// actually release.)
`include "kl10pv.svh"

// This module pretends to be a MB20 core memory. The A phase is
// negedge of mbus.clk and B phase is posedge.
//
// TODO:
// * Implement writing.
// * Implement BLKO PI diagnostic cycle support.
// * Support interleaving.
// * Support ACKN of next word while VALID on current word
module mb20 #(parameter MEMSIZE=512*1024) (iMBUS.memory mbus);
  typedef bit[$clog2(MEMSIZE):0] tMemX;
  W36 mem[] = new[MEMSIZE];
  bit aClk, bClk;
  W36 aData, bData;
  bit aParity, bParity;
  bit [14:35] addr;

  always_comb aClk = ~mbus.clk;
  always_comb bClk =  mbus.clk;

  always_comb mbus.dIn = mbus.validInA ? aData : mbus.validInB ? bData : 0;
  always_comb mbus.parIn = aClk ? aParity : bParity;

  always_latch if (mbus.adrHold) addr = mbus.adr;

  mb20Phase aPhase(.clk(aClk),
		   .reset(mbus.memReset),
		   .start(mbus.startA),
		   .ackn(mbus.acknA),
		   .validIn(mbus.validInA),
		   .validOut(mbus.validOutA),
		   .inRq(mbus.rq),
		   .d(aData),
		   .parity(aParity),
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
		   .*);
endmodule


// This is one phase of the MB20 core memory. For now, we implement
// only read cycles and only non-interleaved organization.
//
// NOTE: START may already be asserted for subsequent cycle while we
// are still finishing up the VALID pulses for the current one.
module mb20Phase (input bit clk,
		  input bit reset,
		  input bit [14:35] addr,
		  input bit [0:3] inRq,
		  output bit validIn,
		  input bit validOut,
		  output W36 d,
		  output bit parity,
		  input bit start,
		  output bit ackn);

  bit [14:35] fullAddr;	      // Address base we start at for quadword
  bit [34:35] wo;	      // Word offset of quadword
  bit [0:3] toAck;	      // Words we have not yet ACKed

  always_ff @(posedge clk)

    if (reset) begin
      toAck <= 0;
      validIn <= 0;
      ackn <= 0;
    end else if (start && toAck == 0) begin     // A transfer is starting
      fullAddr <= addr;		// Address of first word we do
      wo <= addr[34:35];	// Word offset we increment mod 4
      toAck <= inRq;		// Addresses remaining to ACK
      validIn <= 1;
      ackn <= 1;
    end else if (toAck != 0) begin
      wo <= wo + 1;
      toAck <= toAck << 1;
      validIn <= 1;
      ackn <= 1;
    end else begin
      validIn <= 0;
      ackn <= 0;
    end

  always_comb begin
    d = start ? memory0.mem[{fullAddr[14:33], wo}] : 0;
    parity = start ? ^d : 0;
  end

endmodule
