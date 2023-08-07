// Dual 2-wide 2-3 input OR-AND/OR-AND gate
module mc10117(input bit a1, a2, b1, b2, b3c3, c1, c2, d1, d2,
	       output bit qa, nqa, qb, nqb);
   
   always_comb begin
      qa = (a1 | a2) & (b1 | b2 | b3c3);
      nqa = !qa;
      qb = (c1 | c2 | b3c3) & (d1 | d2);
      nqb = !qb;
   end

endmodule // mc10117
