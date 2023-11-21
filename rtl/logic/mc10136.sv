module mc10136(input bit  d8, d4, d2, d1, nCryIn,
	       input bit  sel2, sel1, clk,
	       output bit q8, q4, q2, q1, nCryOut);
  typedef enum bit [1:0] {LOAD, INC, DEC, HOLD} tCounterMode;
  tCounterMode mode = tCounterMode'({sel2, sel1});
  bit ci = !nCryIn;
  bit co;
  
  always_comb begin

    unique case (mode)
      LOAD: co = 1;
      INC:  co = {q8,q4,q2,q1} == 4'b1111;
      DEC:  co = {q8,q4,q2,q1} == '0;
      HOLD: co = 0;
    endcase

    nCryOut = !co;
  end

  always_ff @(posedge clk) begin

    unique case (mode)
      LOAD: {q8,q4,q2,q1} <= {d8,d4,d2,d1};
      INC:  if (ci) {q8,q4,q2,q1} <= {q8,q4,q2,q1} + 4'b0001;
      DEC:  if (ci) {q8,q4,q2,q1} <= {q8,q4,q2,q1} - 4'b0001;
      HOLD: ;
    endcase
  end

endmodule // mc10136
