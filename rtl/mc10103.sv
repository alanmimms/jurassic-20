// Quad 2-input OR gate
module mc10103(input bit a1, a2, b1, b2, c1, c2, d1, d2,
	       output bit qa,
	       output bit qb,
	       output bit qc, nqc,
	       output bit qd);
   
always_comb begin
   {qa, qb, qc, qd} = {a1 | a2, b1 | b2, c1 | c2, d1 | d2};
   nqc = !qc;
end


endmodule // mc10103
