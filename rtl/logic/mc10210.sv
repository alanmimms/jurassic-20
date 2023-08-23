module mc10210(input bit a1,a2,a3, b1,b2,b3,
	       output bit qa1,qa2,qa3, qb1,qb2,qb3);
   
  assign qa1 = a1|a2|a3;
  assign qa2 = qa1;
  assign qa3 = qa1;
  assign qb1 = b1|b2|b3;
  assign qb2 = qb1;
  assign qb3 = qb1;
endmodule // mc10210
