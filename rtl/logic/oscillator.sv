module oscillator(input bit clk, output bit out);
  always_ff @(clk) out <= !out;
endmodule // oscillator
