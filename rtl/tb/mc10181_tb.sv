`include "logic.svh"

module mc10181_tb;
  string GREEN = "\033[32m";
  string RED = "\033[31m";

  bit [0:3] s;
  bit boole;
  bit cin;
  bit [0:3] a;
  bit [0:3] b;
  bit [0:3] f;
  bit cg;
  bit cp;
  bit cout;

  mc10181 dut(s[0],s[1],s[2],s[3], boole, cin,
	      a[0],a[1],a[2],a[3], b[0],b[1],b[2],b[3],
	      f[0],f[1],f[2],f[3], cg,cp, cout);

  typedef struct packed {
    logic [0:3] s;
    logic boole;
    logic cin;
    logic [0:3] a;
    logic [0:3] b;
    logic [0:3] f;
    logic cg;
    logic cp;
    logic cout;
  } StimData;

  StimData stim[4] = {
  //     s    boole cin       a        b        f     cg    cp   cout
    {4'b0000, 1'b0, 1'b0, 4'b1111, 4'b0000, 4'b1111, 1'b0, 1'b0, 1'b0},
    {4'b0000, 1'b0, 1'b0, 4'b1111, 4'b1111, 4'b1111, 1'b0, 1'b0, 1'b0},
    {4'b0000, 1'b0, 1'b0, 4'b0000, 4'b1111, 4'b0000, 1'b0, 1'b0, 1'b0},
    {4'b0000, 1'b0, 1'b0, 4'b1010, 4'b1111, 4'b1010, 1'b0, 1'b0, 1'b0}
  };

  initial begin

    for (int k = 0; k < $size(stim); ++k) begin
      bit pass;

      StimData t = stim[k];
      s = t.s;
      boole = t.boole;
      cin = t.cin;
      a = t.a;
      b = t.b;

      #1
      pass = f == t.f && cg == t.cg && cp == t.cp && cout == t.cout;
      
      $display("%s%7g s=%04b/%01b cin=%01b a=%04b b=%04b  Was/Sb: f=%04b/%04b cgcp=%02b cout=%01b [%s]",
	       pass ? GREEN : RED,
	       $realtime, s, boole, cin, a, b,
	       f, cg, cp, cout,
	       pass ? "PASS" : "FAIL");

    end

    #33
    $finish(0);
  end

endmodule // mc10181_tb
