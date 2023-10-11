module delay3(input bit clk, trigger, output bit q);
  delayN #(.N(3)) d3 (.*);
endmodule
