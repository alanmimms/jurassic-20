// Quad XOR with enable
module mc10113(input bit a1,a2, b1,b2, c1,c2, d1,d2, ne,
	       output bit qa, qb, qc, qd);
  
  always_comb begin
    {qa,qb,qc,qd} = ne ? '0 : {a1 ^ a2, b1 ^ b2, c1 ^ c2, d1 ^ d2};
  end
endmodule // mc10113
