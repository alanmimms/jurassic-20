module mc10144(input bit a0, a1, a2, a3, a4, a5, a6, a7,
	       input bit d, nen1, nen2, nen3, nwrite,
	       output bit q);

  bit ram[255:0];
  bit [7:0] addr;
  bit we, re;

  always_comb we = !nen1 && !nen2 && !nen3 && !nwrite;
  always_comb re = !nen1 && !nen2 && !nen3 && nwrite;
  always_comb addr = {a0,a1,a2,a3,a4,a5,a6,a7};


  always_ff @(posedge re, posedge we) begin

    if (re) ram[addr] <= d;
    else if (we) q <= ram[addr];
    else q <= '0;
  end
endmodule
