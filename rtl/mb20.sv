// TODO: Should the lack ACKN pulse last until START releases? (For
// back-to-back cycles on the same phase I don't know that it will
// actually release.)
`include "kl10pv.svh"

// This module pretends to be a MB20 core memory. The A phase is
// negedge of mbus.clk and B phase is posedge.
//
// TODO:
// * Implement BLKO PI diagnostic cycle support.
// * Support interleaving.
// * Implement hardware memory through DMA to DRAM shared with Linux.
// * Support ACKN of next word while VALID on current word
module mb20 #(parameter MEMSIZE=256*1024) (iMBUS.memory mbus);
  W36 mem[MEMSIZE];
  bit aClk, bClk;
  W36 aData, bData;
  bit aParity, bParity;

  always_comb aClk = ~mbus.clk;
  always_comb bClk =  mbus.clk;

  always_comb mbus.dIn = mbus.inValidA ? aData : mbus.inValidB ? bData : '0;
  always_comb mbus.parIn = aClk ? aParity : bParity;

  mb20Phase #(.MEMSIZE(MEMSIZE)) aPhase(.clk(aClk),
					.reset(mbus.memReset),
					.mem(mem),
					.start(mbus.startA),
					.ackn(mbus.acknA),
					.inValid(mbus.inValidA),
					.outValid(mbus.outValidA),
					.inAddr(mbus.adr),
					.inRq(mbus.rq),
					.d(aData),
					.parity(aParity),
					.*);
  mb20Phase #(.MEMSIZE(MEMSIZE)) bPhase(.clk(bClk),
					.reset(mbus.memReset),
					.mem(mem),
					.start(mbus.startB),
					.ackn(mbus.acknB),
					.inValid(mbus.inValidB),
					.outValid(mbus.outValidB),
					.inAddr(mbus.adr),
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
module mb20Phase #(parameter MEMSIZE)
  (input bit clk,
   input bit reset,
   ref W36 mem[MEMSIZE],
   input bit [14:35] inAddr,
   input bit [0:3] inRq,
   output bit inValid,
   input bit outValid,
   output W36 d,
   output bit parity,
   input bit start,
   output bit ackn);

  bit [14:35] addr;             // Address base we start at for quadword
  bit [34:35] wo;               // Word offset of quadword
  bit [0:3] toAck;              // Words we have not yet ACKed

  assign ackn = toAck[0];
  assign inValid = toAck[0];

  always_comb parity = ^d;
  always_comb d = inValid ? mem[$clog2(MEMSIZE)'({inAddr[14:33], wo})] : 0;

  always_ff @(posedge clk)
    if (reset) begin
      addr <= '0;
      wo <= '0;
      toAck <= '0;
    end else if (start && toAck == '0) begin     // A transfer is starting
      addr <= inAddr;		// Address of first word we do
      wo <= inAddr[34:35];	// Word offset we increment mod 4
      toAck <= inRq;		// Addresses remaining to ACK
    end

  always_ff @(posedge clk)
    if (toAck != '0) begin
      wo <= wo + 1;
      toAck <= toAck << 1;
    end

endmodule
