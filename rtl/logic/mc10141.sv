// This is like MC10141 ECL universal shift register
module mc10141(input bit shft0in,
               input bit d0, d1, d2, d3,
               input bit shft3in,
               input bit op1, op2,
               input bit clk,
               output bit q0, q1, q2, q3);

  always_ff @(posedge clk) begin
    unique case ({op1, op2})
      2'b00: {q0,q1,q2,q3} <= {d0,d1,d2,d3};	     // LOAD
      2'b01: {q0,q1,q2,q3} <= {q1, q2, q3, shft3in}; // SHIFT S3 in
      2'b10: {q0,q1,q2,q3} <= {shft0in, q0, q1, q2}; // SHIFT S0 in
      2'b11: ;					     // HOLD
    endcase
  end
endmodule
