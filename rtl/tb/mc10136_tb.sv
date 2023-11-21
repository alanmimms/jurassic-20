module mc10136_tb;
  typedef enum bit[1:0] {LOAD, INC, DEC, HOLD} tOp;

  bit [3:0] d;
  bit clk, nci;
  tOp sel;
  bit [3:0] q;
  bit nco;

  mc10136 dut(d[3], d[2], d[1], d[0], nci,
	      sel[1], sel[0], clk,
	      q[3], q[2], q[1], q[0], nco);



  `define X 1'bX

  struct {
    bit s1,s2;
    logic d0,d1,d2,d3;
    logic nci;
    bit clk;
    bit q0,q1,q2,q3;
    bit nco;
    } tests [] = {
		 //S1  S2  D0  D1  D2  D3 NCI Clk  Q0  Q1  Q2  Q3  NCO
		  { 0,  0,  0,  0,  1,  1, `X,  1,  0,  0,  1,  1,  0},
		  { 0,  1, `X, `X, `X, `X,  0,  1,  1,  0,  1,  1,  1},
		  { 0,  1, `X, `X, `X, `X,  0,  1,  0,  1,  1,  1,  1},
		  { 0,  1, `X, `X, `X, `X,  0,  1,  1,  1,  1,  1,  0},
		  { 0,  1, `X, `X, `X, `X,  1,  0,  1,  1,  1,  1,  1},
		  { 0,  1, `X, `X, `X, `X,  1,  1,  1,  1,  1,  1,  1},
		  { 1,  1, `X, `X, `X, `X, `X,  1,  1,  1,  1,  1,  1},
		  { 0,  0,  1,  1,  0,  0, `X,  1,  1,  1,  0,  0,  0},
		  { 1,  0, `X, `X, `X, `X,  0,  1,  0,  1,  0,  0,  1},
		  { 1,  0, `X, `X, `X, `X,  0,  1,  1,  0,  0,  0,  1},
		  { 1,  0, `X, `X, `X, `X,  0,  1,  0,  0,  0,  0,  0},
		  { 1,  0, `X, `X, `X, `X,  0,  1,  1,  1,  1,  1,  1}};

  initial begin
    clk = 0;
    nci = 0;
    d = 0;

    for (int k = 0; k < $size(tests); ++k) begin
      #1 clk = tests[k].clk;
      sel = tOp'({tests[k].s2, tests[k].s1});
      d = {tests[k].d3, tests[k].d2, tests[k].d1, tests[k].d0};
      $display("%7g %4s d=%04b nci=%01b clk=%01b  q=%04b nco=%01b",
	       $realtime, sel.name, d, nci, clk, q, nco);

    end

    #100
    $finish(2);
  end

endmodule // mc10136_tb
