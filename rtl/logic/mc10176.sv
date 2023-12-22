module mc10176(input bit d0,d1,d2,d3,d4,d5, clk,
	       output bit q0,q1,q2,q3,q4,q5);
  always @(posedge clk) {q0,q1,q2,q3,q4,q5} <= {d0,d1,d2,d3,d4,d5};
endmodule // mc10176
