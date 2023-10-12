// Like delayN but for active low signal.
module delayNinverted #(parameter N=2) (input bit clk, ntrigger, output bit nq);
  bit q;
  always_comb nq = !q;
  delayN #(.N(N)) delayNI (.clk(clk), .trigger(!ntrigger), .q(q));
endmodule
