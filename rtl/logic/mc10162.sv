module mc10162(input bit sel4, sel2, sel1,
	       nen1, nen2,
	       output bit q0, q1, q2, q3, q4, q5, q6, q7);

  always_comb
    unique case ({!nen1 & !nen2, sel4, sel2, sel1})
      4'b1000: {q0,q1,q2,q3,q4,q5,q6,q7} = 8'b1000_0000;
      4'b1001: {q0,q1,q2,q3,q4,q5,q6,q7} = 8'b0100_0000;
      4'b1010: {q0,q1,q2,q3,q4,q5,q6,q7} = 8'b0010_0000;
      4'b1011: {q0,q1,q2,q3,q4,q5,q6,q7} = 8'b0001_0000;
      4'b1100: {q0,q1,q2,q3,q4,q5,q6,q7} = 8'b0000_1000;
      4'b1101: {q0,q1,q2,q3,q4,q5,q6,q7} = 8'b0000_0100;
      4'b1110: {q0,q1,q2,q3,q4,q5,q6,q7} = 8'b0000_0010;
      4'b1111: {q0,q1,q2,q3,q4,q5,q6,q7} = 8'b0000_0001;
      default: {q0,q1,q2,q3,q4,q5,q6,q7} = 8'b0000_0000;
    endcase // unique case ({!nen1 & !nen2, sel4, sel2, sel1})

endmodule
