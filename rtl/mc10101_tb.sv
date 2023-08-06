module mc10101_tb(input clk);
   bit a1, b1, c1, d1, abcd2;
   bit nqa, qa, nqb, qb, nqc, qc, nqd, qd;

   mc10101 dut(.*);

   initial begin

      for (int i = 0; i < 16; ++i) begin
	 a1 = i[0];
	 b1 = i[1];
	 c1 = i[2];
	 d1 = i[3];
	 abcd2 = i[4];

	 #1 $display($time, " clk=%1b a=%1b b=%1b c=%1b d=%1b abcd2=%1b",
		     clk, a1, b1, c1, d1, abcd2);
	 $display($time, "qa=%1b nqa=%1b  qb=%1b nqb=%1b  qc=%1b nqc=%1b  qd=%1b nqd=%1b",
		  qa, nqa, qb, nqb, qc, nqc, qd, nqd);
      end // for (int i = 0; i < 16; ++i)
   end

endmodule // mc10101_tb
