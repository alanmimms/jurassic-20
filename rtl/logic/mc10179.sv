module mc10179(input bit g8,g4,g2,g1, p8,p4,p2,p1, cin,
               output bit gout, pout, c8out, c2out);

  always_comb c8out = ~|{~g1,
		      ~|{p1, g2},
		      ~|{p1, p2, g4},
		      ~|{p1, p2, p4, g8},
		      ~|{p1, p2, p4, p8, cin}};
  always_comb c2out = ~|{~g4,
		      ~|{p4, g8},
		      ~|{p4, p8, cin}};
  always_comb gout = ~|{~g1,
		     ~|{p1, g2},
		     ~|{p1, p2, g4},
		     ~|{p1, p2, p4, g8}};
  always_comb pout = p1 | p2 | p4 | p8;
endmodule // mc10179
