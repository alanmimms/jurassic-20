`include "logic.svh"
`include "util.svh"

module mc10181_tb;
  string FGCOLOR = "\033[39m";
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

  StimData stim[10] = {
  //     s    boole cin       a        b        f     cg    cp   cout
    {4'b0000, 1'b1, 1'b0, 4'b1111, 4'b0000, 4'b0000, 1'b1, 1'b0, 1'b0},
    {4'b0000, 1'b1, 1'b0, 4'b1111, 4'b1111, 4'b0000, 1'b1, 1'b0, 1'b0},
    {4'b0000, 1'b1, 1'b0, 4'b0000, 4'b1111, 4'b1111, 1'b0, 1'b0, 1'b0},
    {4'b0000, 1'b1, 1'b0, 4'b1010, 4'b1111, 4'b0101, 1'b0, 1'b0, 1'b0},
    {4'b0000, 1'b1, 1'b0, 4'b0101, 4'b1111, 4'b1010, 1'b0, 1'b0, 1'b0},
    {4'b0000, 1'b1, 1'b1, 4'b1111, 4'b0000, 4'b0000, 1'b1, 1'b0, 1'b1},
    {4'b0000, 1'b1, 1'b1, 4'b1111, 4'b1111, 4'b0000, 1'b1, 1'b0, 1'b1},
    {4'b0000, 1'b1, 1'b1, 4'b0000, 4'b1111, 4'b1111, 1'b0, 1'b0, 1'b0},
    {4'b0000, 1'b1, 1'b1, 4'b1010, 4'b1111, 4'b0101, 1'b0, 1'b0, 1'b0},
    {4'b0000, 1'b1, 1'b1, 4'b0101, 4'b1111, 4'b1010, 1'b0, 1'b0, 1'b0}
  };

  initial begin
`define T(V)	$sformatf("\033[39m%s=%b/%s%b\033[39m", `STRINGIFY(V), V, (V == t.V ? GREEN : RED), t.V)

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
      
      $display("\033[39m%7g s=%b.%b cin=%b a=%b b=%b  Was/Sb: %s %s %s %s ---[%s]",
	       $realtime, s, boole, cin, a, b,
	       `T(f), `T(cg), `T(cp), `T(cout),
	       pass ? "\033[32mPASS\033[39m" : "\033[31mFAIL\033[39m");

    end

    #33
    $finish(0);
  end

endmodule // mc10181_tb
