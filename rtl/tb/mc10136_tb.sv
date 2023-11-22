module mc10136_tb;
  typedef enum bit[1:0] {LOAD, DEC, INC, HOLD} tCounterMode;

  string GREEN = "\033[32m";
  string RED = "\033[31m";

  bit [3:0] d;
  bit clk, nci;
  tCounterMode s;
  bit [3:0] q;
  bit nco;

  mc10136 dut(d[3], d[2], d[1], d[0], nci,
	      s[1], s[0], clk,
	      q[3], q[2], q[1], q[0], nco);

  typedef struct packed {
    tCounterMode s;
    bit [3:0] d;
    bit nci;
    bit clk;
    bit [3:0] q;
    bit nco;
  } StimData;

  StimData stim[12] = {
		       'b0011000111000,
		       'b1000000111011,
		       'b1000000111101,
		       'b1000000111110,
		       'b1000001011111,
		       'b1000001111111,
		       'b1100000111111,
		       'b0000110100110,
		       'b0100000100101,
		       'b0100000100011,
		       'b0100000100000,
		       'b0100000111111};

  initial begin

    for (int k = 0; k < $size(stim); ++k) begin
      StimData t = stim[k];
      s = t.s;
      d = t.d;
      nci = t.nci;
      clk = 0;

      #1 clk = t.clk;
      #1
      $display("%s%7g %4s d=%04b nci=%01b clk=%01b  Outputs V/SB: q=%04b/%04b  nco=%01b/%01b  [%s]",
	       (q == t.q && nco == t.nco) ? GREEN : RED,
	       $realtime, s.name, d, nci, clk, q, t.q, nco, t.nco,
	       (q == t.q && nco == t.nco) ? "PASS" : "FAIL");

    end

    #33
    $finish(2);
  end

endmodule // mc10136_tb
