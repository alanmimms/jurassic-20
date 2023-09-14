module mc10145(input bit a0, a1, a2, a3,
	       input bit d0, d1, d2, d3, nen, nwrite,
	       output bit q0, q1, q2, q3);

  bit [3:0] ram[15:0];
  bit [3:0] addr;
  bit we, re;

  always_comb we = !nen && !nwrite;
  always_comb re = !nen && nwrite;
  always_comb addr = {a0,a1,a2,a3};

  always_ff @(posedge re, posedge we) begin

    if (re) ram[addr] <= {d0,d1,d2,d3};
    else if (we) {q0,q1,q2,q3} <= ram[addr];
    else {q0,q1,q2,q3} <= '0;
  end
endmodule
