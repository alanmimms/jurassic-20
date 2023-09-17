module mc10145(input bit a0, a1, a2, a3,
	       input bit d0, d1, d2, d3, nen, nwrite,
	       output bit q0, q1, q2, q3);

  bit [3:0] ram[15:0];
  bit [3:0] addr;
  bit cs, we, re;
  bit [3:0] q;
  bit [3:0] d;

  always_comb cs = !nen;
  always_comb we = cs && !nwrite;
  always_comb re = cs && nwrite;
  always_comb addr = {a0,a1,a2,a3};
  always_comb {q0,q1,q2,q3} = q;
  always_comb d = {d0, d1, d2, d3};

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
