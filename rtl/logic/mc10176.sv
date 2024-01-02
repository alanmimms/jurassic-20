module mc10176(input bit d0,d1,d2,d3,d4,d5, clk,
	       output bit q0,q1,q2,q3,q4,q5);
  bit [0:5] value;

  always_comb {q0,q1,q2,q3,q4,q5} = value;
  always @(posedge clk) value <= {d0,d1,d2,d3,d4,d5};
endmodule // mc10176
