module mc10415a(input bit a0, a1, a2, a3, a4, a5, a6, a7, a8, a9,
		input bit d, nen, nwrite,
		output bit q);

  bit ram[1023:0];
  bit [9:0] addr;
  bit we, re;

  always_comb we= !nen && !nwrite;
  always_comb re = !nen && nwrite;
  always_comb addr = {a0,a1,a2,a3,a4,a5,a6,a7,a8,a9};

  always_ff @(posedge re, posedge we) begin

    if (re) ram[addr] <= d;
    else if (we) q <= ram[addr];
    else q <= '0;
  end
endmodule
