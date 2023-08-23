module mc10161(input bit sel4, sel2, sel1,
	       nen1, nen2,
	       output bit nq0, nq1, nq2, nq3, nq4, nq5, nq6, nq7);

  always_comb
    unique case ({!nen1 & !nen2, sel4, sel2, sel1})
      4'b1000: {nq0,nq1,nq2,nq3,nq4,nq5,nq6,nq7} = ~8'b1000_0000;
      4'b1001: {nq0,nq1,nq2,nq3,nq4,nq5,nq6,nq7} = ~8'b0100_0000;
      4'b1010: {nq0,nq1,nq2,nq3,nq4,nq5,nq6,nq7} = ~8'b0010_0000;
      4'b1011: {nq0,nq1,nq2,nq3,nq4,nq5,nq6,nq7} = ~8'b0001_0000;
      4'b1100: {nq0,nq1,nq2,nq3,nq4,nq5,nq6,nq7} = ~8'b0000_1000;
      4'b1101: {nq0,nq1,nq2,nq3,nq4,nq5,nq6,nq7} = ~8'b0000_0100;
      4'b1110: {nq0,nq1,nq2,nq3,nq4,nq5,nq6,nq7} = ~8'b0000_0010;
      4'b1111: {nq0,nq1,nq2,nq3,nq4,nq5,nq6,nq7} = ~8'b0000_0001;
      default: {nq0,nq1,nq2,nq3,nq4,nq5,nq6,nq7} = ~8'b0000_0000;
    endcase // unique case ({!nen1 & !nen2, sel4, sel2, sel1})

endmodule
