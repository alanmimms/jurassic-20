// Quad 2-input AND gate
module mc10104(input bit a1, a2, b1, b2, c1, c2, d1, d2,
	       output bit qa,
	       output bit qb,
	       output bit qc,
	       output bit qd, nqd);
   
always_comb begin
   {qa, qb, qc, qd} = {a1 & a2, b1 & b2, c1 & c2, d1 & d2};
   nqd = !qd;
end


endmodule // mc10104
