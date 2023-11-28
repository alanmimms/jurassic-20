// Dual 2-wide 3-input OR-AND gate
module mc10118(input bit a1, a2, a3, b1, b2, b3c3, c1, c2, d1, d2, d3,
	       output bit qab, qcd);
   
  always_comb begin
    qab = (a1 | a2 | a3) & (b1 | b2 | b3c3);
    qcd = (c1 | c2 | b3c3) & (d1 | d2 | d3);
  end
endmodule // mc10118
