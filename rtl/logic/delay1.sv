module delay1(input bit clk, trigger, output bit q);
  delayN #(.N(1)) d1 (.*);
endmodule
