module mc10145(input bit a0, a1, a2, a3,
	       input bit d0, d1, d2, d3, nen, nwrite,
	       output bit q0, q1, q2, q3);

  bit [3:0] ram[0:15];
  bit [3:0] addr;
  bit cs, we;

  always_comb cs = !nen;
  always_comb we = cs && !nwrite;
  always_comb addr = {a0,a1,a2,a3};
  always_comb {q0,q1,q2,q3} = !we ? ram[addr] : 0;

  always @(negedge we) begin
    ram[addr] <= {d0,d1,d2,d3};
  end
endmodule
