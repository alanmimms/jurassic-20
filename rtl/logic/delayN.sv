// Starting with leading edge of `trigger` assert `q` delayed by N
// edges and then deassert `q` N edges after `trigger` deasserts.
module delayN #(parameter N=2)
  (input bit clk,
   input bit trigger,
   output bit q);

  bit [3:0] toOnCount = 0;
  bit [3:0] toOffCount = N;

  always_comb q = toOnCount == N;

  always_ff @(posedge clk, negedge clk) begin

    if (trigger && toOnCount != N) begin
      toOnCount <= toOnCount + 1;
      toOffCount <= N;
    end

    if (!trigger) begin

      if (toOffCount > 1)
	toOffCount <= toOffCount - 1;
      else begin
	toOnCount <= 0;
	toOffCount <= N;
      end
    end
  end
endmodule
