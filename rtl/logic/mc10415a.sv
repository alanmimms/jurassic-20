module mc10415a(input bit a0, a1, a2, a3, a4, a5, a6, a7, a8, a9,
		input bit d, nen, nwrite,
		output bit q);

  bit ram[1023:0];
  bit [0:9] addr;
  bit cs, we;

  always_comb cs = !nen;
  always_comb we = cs && !nwrite;
  always_comb addr = {a0,a1,a2,a3,a4,a5,a6,a7,a8,a9};

  always_ff @(addr, cs, we) begin

    if (cs) begin

      if (we) begin
	ram[addr] <= d;
	q <= '0;
      end else
	q <= ram[addr];

    end else
      q <= '0;

  end // always_ff @ (addr, posedge cs, posedge we)
endmodule
