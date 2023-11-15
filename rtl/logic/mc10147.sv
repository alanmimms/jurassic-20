module mc10147(input bit a0, a1, a2, a3, a4, a5, a6,
	       input bit d, nen1, nen2, nwrite,
	       output bit q);

  bit ram[128];
  bit [6:0] addr;
  bit cs, we, re;

  always_comb begin
    cs = !nen1 && !nen2;
    we = cs && !nwrite;
    re = cs && nwrite;
    addr = {a0,a1,a2,a3,a4,a5,a6};
    q = re ? ram[addr] : 0;
  end

  always_ff @(we) begin
    if (we) ram[addr] <= d;
  end
endmodule
