module mc10210(input bit a1,a2,a3, b1,b2,b3,
	       output bit qa1,qa2,qa3, qb1,qb2,qb3);
   
  always_comb qa1 = a1|a2|a3;
  always_comb qa2 = qa1;
  always_comb qa3 = qa1;
  always_comb qb1 = b1|b2|b3;
  always_comb qb2 = qb1;
  always_comb qb3 = qb1;
endmodule // mc10210
