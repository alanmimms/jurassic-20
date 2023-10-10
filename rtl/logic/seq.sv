module seq (input bit clk,
	    input bit reset,
	    output bit q7, q6, q5, q4, q3, q2, q1, q0);

  bit [3:0] state = 0;
  bit running = 0;

  always_comb begin
    {q7,q6,q5,q4,q3,q2,q1,q0} = 0;

    unique case (state)
    0: q0 = 1;
    1: q1 = 1;
    2: q2 = 1;
    3: q3 = 1;
    4: q4 = 1;
    5: q5 = 1;
    6: q6 = 1;
    7: q7 = 1;
    endcase
  end // always_comb

  always @(posedge clk, negedge clk) begin

    if (running) begin

      if (state < 5) begin
	state <= state + 1;
      end else begin
	state <= 0;
	running <= 0;
      end
    end else if (!running && !reset) running <= 1;
  end
endmodule
