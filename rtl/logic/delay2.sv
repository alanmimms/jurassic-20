module delay2(input bit clk, trigger, output bit q);
  delayN #(.N(2)) d2 (.*);
endmodule
