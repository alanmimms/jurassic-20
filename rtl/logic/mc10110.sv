// Dual 3-input/3-output OR
module mc10110(input bit a1, a2, a3, b1, b2, b3,
	       output bit qa1, qa2, qa3,
	       output bit qb1, qb2, qb3);
   
   always_comb begin
      qa1 = a1 | a2 | a3;
      qa2 = qa1;
      qa3 = qa1;
      
      qb1 = b1 | b2 | b3;
      qb2 = qb1;
      qb3 = qb1;
   end

endmodule // mc10110
