// Dual 4-5 input OR/NOR
module mc10109(input bit a1, a2, a3, a4, b1, b2, b3, b4, b5,
	       output bit qa, nqa,
	       output bit qb, nqb);
  
  always_comb begin
    qa = a1 | a2 | a3 | a4;
    nqa = !qa;
    qb = b1 | b2 | b3 | b4 | b5;
    nqb = !qb;
  end
endmodule // mc10109
