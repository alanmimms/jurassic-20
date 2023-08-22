// Dual D type MS flipflop
module mc10131(input bit sa, da, cea, ra, clk, sb, db, ceb, rb,
	       output bit qa, nqa, qb, nqb);

   assign nqa = !qa;
   assign nqb = !qb;
   
   always_ff @(posedge clk | cea, posedge ra, posedge sa)
     if (ra) qa <= '0;
     else if (sa) qa <= '1;
     else qa <= da;

   always_ff @(posedge clk | ceb, posedge rb, posedge sb)
     if (rb) qb <= '0;
     else if (sb) qb <= '1;
     else qb <= db;

endmodule // mc10131
