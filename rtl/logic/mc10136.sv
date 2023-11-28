module mc10136(input bit  d8, d4, d2, d1, nCryIn,
	       input bit  sel2, sel1, clk,
	       output bit q8, q4, q2, q1, nCryOut);
  typedef enum bit [1:0] {LOAD, DEC, INC, HOLD} tCounterMode;
  tCounterMode mode;
  bit [3:0] value;
  bit [3:0] ci;
  bit co;
  
  always_comb begin
    mode = tCounterMode'({sel2, sel1});
    ci = 4'(!nCryIn);
  end

  always_ff @(posedge clk) begin

    unique case (mode)
      LOAD: value <= {d8,d4,d2,d1};
      INC: value <= value + ci;
      DEC: value <= value - ci;
      HOLD: value <= value;
    endcase
  end

  always_comb begin

    unique case (mode)
      LOAD: co = 1;
      INC:  co = ci[0] & (value == 4'b1111);
      DEC:  co = ci[0] & (value == 4'b0000);
      HOLD: co = 0;
    endcase

    nCryOut = !co;
    {q8,q4,q2,q1} = value;
  end

endmodule // mc10136
