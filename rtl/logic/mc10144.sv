module mc10144(input bit a0, a1, a2, a3, a4, a5, a6, a7,
	       input bit d, nen1, nen2, nen3, nwrite,
	       output bit q);
  bit ram[0:255];
  bit [7:0] addr;

  always_comb begin
    q = (!(nen1 | nen2 | nen3) && nwrite) ? ram[{a0,a1,a2,a3,a4,a5,a6,a7}] : 0;
  end

  always_ff @(negedge nwrite) begin
    if (!(nen1 | nen2 | nen3)) ram[{a0,a1,a2,a3,a4,a5,a6,a7}] <= d;
  end
endmodule
