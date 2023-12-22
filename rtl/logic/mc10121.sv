// 2-wide OR-AND/NAND-NOR gate
module mc10121(input bit a1, a2, a3, b1, b2, b3c3, c1, c2, d1, d2, d3,
	       output bit qa, nqa);
  
  always_comb begin

    qa = (a1 | a2 | a3) &
	 (b1 | b2 | b3c3) &
	 (c1 | c2 | b3c3) &
	 (d1 | d2 | d3);

    nqa = ~(a1 | a2 | a3) |
	  ~(b1 | b2 | b3c3) |
	  ~(c1 | c2 | b3c3) |
	  ~(d1 | d2 | d3);
  end
endmodule // mc10121
