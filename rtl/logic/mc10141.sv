// This is like MC10141 ECL universal shift register
module mc10141(input bit shft0in,
               input bit d0, d1, d2, d3,
               input bit shft3in,
               input bit op2, op1,
               input bit clk,
               output bit q0, q1, q2, q3);

  // SHIFTR is defined as shifting shft3in into q3 and {q0,q1,q2} = previous {q1,q2,q3}.
  // SHIFTL is defined as shifting shft0in into q0 and {q1,q2,q3} = previous {q0,q1,q2}.
  typedef enum bit [1:0] {LOAD, SHIFTL, SHIFTR, HOLD} tMode;
  tMode mode = tMode'({op2, op1});
  bit [0:3] value;

  always_ff @(posedge clk) begin
    unique case (mode)
      LOAD:   value <= {d0,d1,d2,d3};
      SHIFTR: value <= {value[1:3], shft3in};
      SHIFTL: value <= {shft0in, value[0:2]};
      HOLD:   value <= value;
    endcase
  end

  always_comb {q0,q1,q2,q3} = value;
endmodule
