module seq (input bit clk,
	    input bit reset,
	    output bit q7, q6, q5, q4, q3, q2, q1, q0);

  bit [3:0] state = 0;
  bit wasReset;

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
    if (reset) wasReset <= 1;

    if (!reset && wasReset) begin
      state <= 0;
      wasReset <= 0;
    end else begin
      state <= state != 7 ? state + 1 : 0;
    end
  end
endmodule
