module mc10176(input bit d0,d1,d2,d3,d4,d5,
	       clk,
	       output bit q0,q1,q2,q3,q4,q5);

  always_ff @(posedge clk) begin
    q0 <= d0;
    q1 <= d1;
    q2 <= d2;
    q3 <= d3;
    q4 <= d4;
    q5 <= d5;
  end

endmodule
