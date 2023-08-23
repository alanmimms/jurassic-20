module mc10179(input bit g8,g4,g2,g1, p8,p4,p2,p1, cin,
               output bit gout, pout, c8out, c2out);

  assign c8out = ~|{~g1,
                    ~|{p1, g2},
                    ~|{p1, p2, g4},
                    ~|{p1, p2, p4, g8},
                    ~|{p1, p2, p4, p8, cin}};
  assign c2out = ~|{~g4,
                    ~|{p4, g8},
                    ~|{p4, p8, cin}};
  assign gout = ~|{~g1,
                   ~|{p1, g2},
                   ~|{p1, p2, g4},
                   ~|{p1, p2, p4, g8}};
  assign pout = p1 | p2 | p4 | p8;
endmodule // mc10179
