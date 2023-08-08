module mc10101(input bit a1, b1, c1, d1, abcd2,
	       output bit nqa, qa,
	       output bit nqb, qb,
	       output bit nqc, qc,
	       output bit nqd, qd);
   
always_comb begin
   {qa, qb, qc, qd} = {a1, b1, c1, d1} | {4{abcd2}};
   nqa = !qa;
   nqb = !qb;
   nqc = !qc;
   nqd = !qd;
end


endmodule // mc10101
