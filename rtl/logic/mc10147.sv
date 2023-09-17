module mc10147(input bit a0, a1, a2, a3, a4, a5, a6,
	       input bit d, nen1, nen2, nwrite,
	       output bit q);

  bit ram[127:0];
  bit [6:0] addr;
  bit cs, we, re;

  always_comb cs = !nen1 && !nen2;
  always_comb we = cs && !nwrite;
  always_comb re = cs && nwrite;
  always_comb addr = {a0,a1,a2,a3,a4,a5,a6};

  always_ff @(cs, re, we) begin

    if (cs) begin

      if (we) begin
	ram[addr] <= d;
	q <= '0;
      end else if (re)
	q <= ram[addr];
      else
	q <= '0;

    end else
      q <= '0;
  end
endmodule
