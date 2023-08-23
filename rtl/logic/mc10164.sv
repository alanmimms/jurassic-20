module mc10164(input bit d0,d1,d2,d3,d4,d5,d6,d7,
	       sel4, sel2, sel1,
	       nen,
	       output bit b);

  always_comb
    unique case ({nen, sel4, sel2, sel1})
      4'b0000: b = d0;
      4'b0001: b = d1;
      4'b0010: b = d2;
      4'b0011: b = d3;
      4'b0100: b = d4;
      4'b0101: b = d5;
      4'b0110: b = d6;
      4'b0111: b = d7;
      default: b = '0;
    endcase
endmodule
