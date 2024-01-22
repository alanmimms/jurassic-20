// TODO: Should the lack ACKN pulse last until START releases? (For
// back-to-back cycles on the same phase I don't know that it will
// actually release.)
`include "kl10pv.svh"

// This module pretends to be a MB20 core memory. The A phase is
// negedge of mbus.clk and B phase is posedge.
//
// TODO:
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


// Two phases write to memory, and we know they do not do it
// simultaneously, so we can ignore MULTIDRIVEN lint warning.
//
// verilator lint_off MULTIDRIVEN
module mb20 #(parameter MEMSIZE=512*1024) (iMBUS.memory mbus);
  W36 mem[] = new[MEMSIZE];
  bit aClk, bClk;
  W36 aData, bData;
  bit aParity, bParity;
  bit aOwns;
  tMemAddr addr;

  // Timing of these two clocks is shown in
  // `EK-MB020-UD-001_Dec76.pdf` PDF18.  Although this page documents
  // the diagnostic cycle, it shows the clocks for any cycle.
  always_comb aClk = !mbus.clk;
  always_comb bClk =  mbus.clk;

  // This handles muxing the D bus and its parity for A/B.
  always_comb begin
    mbus.dIn = aOwns ? aData : bData;
    mbus.parIn = aClk ? aParity : bParity;
  end

  always_ff @(posedge mbus.adrHold) begin
    addr <= mbus.adr;
  end

  // Flip driving ownership of mbus.dIn so that A owns it during A
  // cycles and B grabs it when A is not using it.
  always @(posedge mbus.startA, posedge mbus.startB) aOwns <= mbus.startA;

  always @(posedge mbus.startA, posedge mbus.startB) begin

    if (feSim.dumpMemAccesses) begin
      int dumpFD = feSim.dumpFD;

      if (mbus.rdRq) $fdisplay(dumpFD, "%7g ----> MB20 READ  mem[%1o]=%s", $realtime,
			       mbus.adr, feSim.fmt36(mem[mbus.adr]));

      if (mbus.wrRq) $fdisplay(dumpFD, "%7g ----> MB20 WRITE mem[%1o]=%s", $realtime,
					 mbus.adr, feSim.fmt36(mbus.dOut));
    end
  end

  mb20Phase aPhase(.clk(aClk),
		   .reset(mbus.memReset),
		   .start(mbus.startA),
		   .rdRq(mbus.rdRq),
		   .wrRq(mbus.wrRq),
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
		   .rdRq(mbus.rdRq),
		   .wrRq(mbus.wrRq),
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
module mb20Phase (input bit clk,
		  input bit reset,
		  input tMemAddr addr,
		  input bit [0:3] inRq,
		  output bit validIn,
		  input bit validOut,
		  output W36 d,
		  output bit parity,
		  input bit start,
		  input bit rdRq,
		  input bit wrRq,
		  input bit diag,
		  output bit ackn);

  // This is the sequence:
  //
  // 1. Assert `start` to start the cycle. MEM RD/WR RQ or both are
  //    qualifiers.  MEM RQ 0-3 indicate which words are requested. MEM ADR
  //    14-35 are address of first word. MB20 registers nextAdr = MEM ADR 14-35,
  //    MEM RQ 0-3.
  //
  // 2. For each clock while there remain bits in MEM RD/WR RQ to be
  //    done, MB20 asserts SBUS ACKN A/B and also SBUS DATA VALID A/B while
  //    asserting the data (for read or rpw) or registering the incoming
  //    data (write).

  tMemAddr nextAddr = 0;      // Address of word we read/write next.
  bit [0:3] toAck;	      // Flags for words we have not yet ACKed
  W36 word;		      // Word we are returning this cycle

  // Copied at START edge from MBUS because MBUS rdRq/wrRq are deasserted
  // after START deassert.
  bit isRdRq, isWrRq;

  enum bit [4:0] {
    IDLE,		      // No cycle is running
    ACK,		      // ACK the address
    READDATA,		      // Present a word to MBOX
    POST		      // Second clock (needed?) for READ or WRITE
  } state = IDLE;

  always_ff @(posedge start) begin
    isRdRq <= rdRq;
    isWrRq <= wrRq;
  end

  always_ff @(posedge clk) begin
    string words[$] = feSim.split($sformatf("%m"), ".");
    string phase = words[3];	// XXX HaxRUs

    if (diag) begin
      int dumpFD = feSim.dumpFD;

      if (feSim.dumpDiagFuncs) $fdisplay(dumpFD, "%7g ----> %m MB20 DIAG", $realtime);
    end

    if (reset) begin
      state <= IDLE;
    end else begin

      unique case (state)

	IDLE:

	  if (!start) begin
	    // No active cycle: reset
	    toAck <= 0;
	    validIn <= 0;
	    ackn <= 0;
	    nextAddr <= 0;
	    word <= 36'o123456_654321;

	    state <= IDLE;
	  end else begin
	    // Starting an active cycle
	    state <= ACK;
	  end

	ACK: begin
	  ackn <= inRq[0];
	  toAck <= inRq << 1;
	  nextAddr <= addr;

	  state <= READDATA;
	end

	READDATA: begin
	  word <= memory0.mem[nextAddr];
	  validIn <= inRq[0];
	  nextAddr <= {nextAddr[14:33], nextAddr[34:35] + 2'b01};

	  ackn <= 0;

	  state <= POST;
	end

	POST: begin
	  // Always move the flags of words to ACKN forward on each
	  // cycle.
	  toAck <= toAck << 1;

	  if (toAck == 0) begin
	    // No more words to ack, return to idle
	    validIn <= 0;

	    state <= IDLE;
	  end else if (toAck[0]) begin
	    // This word needs to be transferred
	    ackn <= 1;

	    // No more clocks are needed for a write cycle.
	    // We just ACKN and move on.
	    if (isWrRq) begin
	      word <= d;

	      memory0.mem[nextAddr] <= d;

	      nextAddr <= {nextAddr[14:33], nextAddr[34:35] + 2'b01};

	      ackn <= 0;
	    end else begin
	      validIn <= 1;
	    end

	    state <= isWrRq ? POST : READDATA;
	  end else begin
	    // This word needs to be skipped, but there are still some to do
	    ackn <= 0;
	    validIn <= 0;

	    state <= (toAck << 1) == 0 ? IDLE : POST;
	  end
	end // case: POST

	default: state <= IDLE;
      endcase
    end // else: !if(reset)
  end // always_ff @ (posedge clk)

  always_comb begin
    d = word;
    parity = !^word;
  end
endmodule

// verilator lint_on MULTIDRIVEN
