module mc10136(input bit  d8, d4, d2, d1, nCryIn,
	       input bit  sel2, sel1, clk,
	       output bit q8, q4, q2, q1, nCryOut);
  
  bit [1:0] sel = {sel2, sel1};

  // Not LOAD or HOLD
  bit incOrDec = sel[0] ^ sel[1];

  // nCryIn overrides clk when in INC or DEC mode. This signal is the
  // real clock we have to pay attention to as a result.
  bit carryClk;

  bit carryOut, carryIn;
  assign carryIn = !nCryIn;

  always_comb nCryOut = !carryOut;
  always_comb carryClk = incOrDec ? clk : !nCryIn;

  always_comb begin
    unique case (sel[1:0])
      2'b00: carryOut = 1;			  // LOAD
      2'b01: carryOut = {q8,q4,q2,q1} == 4'b1111; // INC
      2'b10: carryOut = {q8,q4,q2,q1} == '0;	  // DEC
      2'b11: carryOut = 0;			  // HOLD
    endcase
  end

  always_ff @(posedge carryClk) begin
    unique case (sel[1:0])
      2'b00: {q8,q4,q2,q1} <= {d8,d4,d2,d1};				// LOAD
      2'b01: if (carryIn) {q8,q4,q2,q1} <= {q8,q4,q2,q1} + 4'b0001;	// INC
      2'b10: if (carryIn) {q8,q4,q2,q1} <= {q8,q4,q2,q1} - 4'b0001;	// DEC
      2'b11: ;								// HOLD
    endcase
  end

endmodule // mc10101
