`timescale 1ns/1ns
module mc10179(input bit [0:3] G,
               input bit [0:3] P,
               input bit CIN,

               output bit GG,
               output bit PG,
               output bit C8OUT,
               output bit C2OUT);

  assign C8OUT = ~|{~G[3],
                    ~|{P[3], G[2]},
                    ~|{P[3], P[2], G[1]},
                    ~|{P[3], P[2], P[1], G[0]},
                    ~|{P[3], P[2], P[1], P[0], CIN}};
  assign C2OUT = ~|{~G[1],
                    ~|{P[1], G[0]},
                    ~|{P[1], P[0], CIN}};
  assign GG = ~|{~G[3],
                 ~|{P[3], G[2]},
                 ~|{P[3], P[2], G[1]},
                 ~|{P[3], P[2], P[1], G[0]}};
  assign PG = P[3] | P[2] | P[1] | P[0];
endmodule // mc10179
