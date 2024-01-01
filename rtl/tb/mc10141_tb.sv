`include "logic.svh"

module mc10141_tb;
//  typedef enum bit[1:0] {LOAD, SHIFTL, SHIFTR, HOLD} tMode;

  string GREEN = "\033[32m";
  string RED = "\033[31m";

  bit [0:3] d;
  bit clk, d0In, d3In;
  tMode141 s;
  bit [0:3] q;

  mc10141 dut(d0In,
	      d[0], d[1], d[2], d[3],
	      d3In,
	      s[1], s[0],
	      clk,
	      q[0], q[1], q[2], q[3]);

  typedef struct packed {
    bit needsClock;
    tMode141 s;
    bit d0In;
    bit [0:3] d;
    bit d3In;
    bit [0:3] q;
  } StimData;

  StimData stim[41] = {
                       {1'b1, LOAD,   1'b1, 4'b1010, 1'b0, 4'b1010},
                       {1'b1, LOAD,   1'b1, 4'b0101, 1'b1, 4'b0101},
                       {1'b1, LOAD,   1'b1, 4'b0000, 1'b1, 4'b0000},
                       {1'b1, LOAD,   1'b0, 4'b1111, 1'b0, 4'b1111},

                       {1'b0, LOAD,   1'b0, 4'b1111, 1'b0, 4'b1111},
                       {1'b0, LOAD,   1'b1, 4'b0000, 1'b1, 4'b1111},
                       {1'b1, LOAD,   1'b1, 4'b0000, 1'b1, 4'b0000},
                       {1'b0, LOAD,   1'b0, 4'b1111, 1'b1, 4'b0000},
                       {1'b0, LOAD,   1'b1, 4'b0000, 1'b0, 4'b0000},

                       {1'b1, LOAD,   1'b1, 4'b1010, 1'b0, 4'b1010},
                       {1'b1, LOAD,   1'b1, 4'b0101, 1'b1, 4'b0101},
                       {1'b1, LOAD,   1'b1, 4'b0000, 1'b1, 4'b0000},
                       {1'b1, LOAD,   1'b0, 4'b1111, 1'b0, 4'b1111},

                       {1'b1, LOAD,   1'b0, 4'b0000, 1'b0, 4'b0000},
                       {1'b1, SHIFTR, 1'b0, 4'b0000, 1'b1, 4'b0001},
                       {1'b1, SHIFTR, 1'b1, 4'b0000, 1'b1, 4'b0011},
                       {1'b1, SHIFTR, 1'b0, 4'b1010, 1'b1, 4'b0111},
                       {1'b1, SHIFTR, 1'b1, 4'b0101, 1'b1, 4'b1111},
                       {1'b1, SHIFTR, 1'b0, 4'b0111, 1'b1, 4'b1111},
                       {1'b1, SHIFTR, 1'b0, 4'b0011, 1'b0, 4'b1110},
                       {1'b1, SHIFTR, 1'b0, 4'b1111, 1'b0, 4'b1100},
                       {1'b1, SHIFTR, 1'b1, 4'b0000, 1'b0, 4'b1000},
                       {1'b1, SHIFTR, 1'b0, 4'b0000, 1'b0, 4'b0000},
                       {1'b1, SHIFTR, 1'b1, 4'b0000, 1'b0, 4'b0000},

                       {1'b1, SHIFTL, 1'b1, 4'b0000, 1'b1, 4'b1000},
                       {1'b1, SHIFTL, 1'b1, 4'b0000, 1'b0, 4'b1100},
                       {1'b1, SHIFTL, 1'b1, 4'b1111, 1'b0, 4'b1110},
                       {1'b1, SHIFTL, 1'b1, 4'b0000, 1'b1, 4'b1111},
                       {1'b1, SHIFTL, 1'b0, 4'b0000, 1'b0, 4'b0111},
                       {1'b1, SHIFTL, 1'b0, 4'b0000, 1'b0, 4'b0011},
                       {1'b1, SHIFTL, 1'b0, 4'b0000, 1'b0, 4'b0001},
                       {1'b1, SHIFTL, 1'b0, 4'b0000, 1'b1, 4'b0000},
                       {1'b1, SHIFTL, 1'b0, 4'b1010, 1'b0, 4'b0000},
                       {1'b1, SHIFTL, 1'b0, 4'b1000, 1'b1, 4'b0000},

                       {1'b1, LOAD,   1'b0, 4'b1010, 1'b0, 4'b1010},
                       {1'b1, HOLD,   1'b1, 4'b1111, 1'b1, 4'b1010},
                       {1'b1, HOLD,   1'b0, 4'b0000, 1'b0, 4'b1010},
                       {1'b1, HOLD,   1'b0, 4'b0101, 1'b0, 4'b1010},
                       {1'b1, HOLD,   1'b0, 4'b0000, 1'b0, 4'b1010},

                       {1'b1, LOAD,   1'b0, 4'b0101, 1'b0, 4'b0101},
                       {1'b1, LOAD,   1'b0, 4'b1010, 1'b0, 4'b1010}};

  initial begin

    for (int k = 0; k < $size(stim); ++k) begin
      StimData t = stim[k];
      s = t.s;
      d0In = t.d0In;
      d = t.d;
      d3In = t.d3In;
      clk = 0;

      if (t.needsClock) begin
        #1 clk = 1;
        #1 clk = 0;
      end

      $display("%s%7g %s %4s d0In=%01b d=%04b d3In=%01b clk=%01b  Was/Sb: q=%04b/%04b  [%s]",
	       (q == t.q) ? GREEN : RED,
	       $realtime, t.needsClock ? "CLOCKED" : "NOTCLKD",
	       s.name, d0In, d, d3In, clk, q, t.q,
	       (q == t.q) ? "PASS" : "FAIL");

    end

    #33
    $finish(0);
  end

endmodule // mc10141_tb
