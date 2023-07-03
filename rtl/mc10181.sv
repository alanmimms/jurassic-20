`timescale 1ns/1ns
// MC10181 from Fairchild ECL datasheet F10181.pdf.
//
// S3 S2 S1 S0    M=1 C0=X    M=0 C0=0     M=0 C0=1
//-------------------------------------------------------
//  0  0  0  0    ~A          A            A+1
//  0  0  0  1    ~A|~B       A+(A&~B)     A+(A&~B)+1
//  0  0  1  0    ~A|B        A+(A&B)      A+(A&B)+1
//  0  0  1  1    1111        A+A          A+A+1
//  0  1  0  0    ~A&~B       A|B          (A|B)+1
//  0  1  0  1    ~B          (A|B)+(A&~B) (A|B)+(A&~B)+1
//  0  1  1  0    ~(A^B)      A+B          A+B+1
//  0  1  1  1    A|~B        (A|B)+A      (A|B)+A+1
//  1  0  0  0    ~A&B        A|~B         (A|~B)+1
//  1  0  0  1    A^B         A-B-1        A-B
//  1  0  1  0    B           (A|~B)+(A&B) (A|~B)+(A&B)+1
//  1  0  1  1    A|B         (A|~B)+A     (A|~B)+A+1
//  1  1  0  0    0000        -1           0000
//  1  1  0  1    A&~B        (A&~B)-1     A&~B
//  1  1  1  0    A&B         (A&B)-1      A&B
//  1  1  1  1    A           A-1          A
module mc10181(input bit [0:3] S,
               input bit M,
               input bit [0:3] A,
               input bit [0:3] B,
               input bit CIN,
               output bit [0:3] F,
               output bit CG,
               output bit CP,
               output bit COUT);

  bit [3:0] G, P;
  bit notGG;

  assign G = ~(~({4{S[3]}} | B | A) | ~({4{S[2]}} | A  | ~B));
  assign P = ~(~({4{S[1]}} | ~B   ) | ~({4{S[0]}} | B) | ~A);
  assign F = ~(G ^ P ^
               {~(M | G[2]) |
                ~(M | P[2] | G[1]) |
                ~(M | P[2] | P[1] | G[0]) |
                ~(M | P[2] | P[1] | P[0] | CIN),

                ~(M | G[1]) |
                ~(M | P[1] | G[0]) |
                ~(M | P[1] | P[0] | CIN),

                ~(M | G[0]) |
                ~(M | P[0] | CIN),

                ~(M | CIN)});
  assign notGG = ~G[3] |
                 ~(P[3] | G[2]) |
                 ~(P[3] | P[2] | G[1]) |
                 ~(P[3] | P[2] | P[1] | G[0]);
  assign CG = ~notGG;
  assign CP = ~|P;
  assign COUT = ~(notGG | ~(CP | CIN));
endmodule // mc10181


`ifdef TESTBENCH
module mc10181_tb;

  bit clk;
  bit [3:0] S, A, B;
  bit [3:0] F;
  bit M, CIN;
  bit CG, CP, COUT;
  bit [31:0] s, a, b;
  bit [31:0] m, cin;

  mc10181 mc10181(.S(S), .M(M), .A(A), .B(B), .CIN(CIN), .F(F), .CG(CG), .CP(CP), .COUT(COUT));

  always #1 clk = ~clk;

  initial begin
    clk = 0;
    cin = 0;

    for (m = 0; m < 2; m = m + 1) begin
      M = m;

      for (s = 0; s < 16; s = s + 1) begin
        S = s;

        for (b = 0; b < 16; b = b + 1) begin
          B = b;

          for (a = 0; a < 16; a = a + 1) begin
            #1 A = a;
            cin = ~cin;
            CIN = cin;
          end
        end
      end
    end
  end

  initial begin
    $monitor("T=%-6D M=%b S=%4b A=%4b B=%4b CIN=%b F=%4b CG=%b CP=%b COUT=%b",
             $time, M, S, A, B, CIN, F, CG, CP, COUT);
    $dumpfile("mc10181_tb.vcd");
    $dumpvars(0, mc10181_tb);
  end
endmodule // mc10181_tb
`endif //  `ifdef TESTBENCH
