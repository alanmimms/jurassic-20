// Triple 2-3-2 input OR/NOR gate
module mc10105(input bit a1,a2, b1,b2,b3, c1,c2,
	       output bit qa, nqa,
	       output bit qb, nqb,
	       output bit qc, nqc);
  
  always_comb begin
    qa = a1 | a2;
    nqa = !qa;
    qb = b1 | b2 | b3;
    nqb = !qb;
    qc = c1 | c2;
    nqc = !qc;
  end
endmodule // mc10105
