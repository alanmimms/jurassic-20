module mc10174(input bit d00,d01,d02,d03, d10,d11,d12,d13,
	       sel2, sel1, nen,
	       output bit b0,b1);

  always_comb

    unique case ({nen, sel2, sel1})
      3'b000: {b0,b1} = {d00,d10};
      3'b001: {b0,b1} = {d01,d11};
      3'b010: {b0,b1} = {d02,d12};
      3'b011: {b0,b1} = {d03,d13};
      default: {b0,b1} = '0;
    endcase // unique case ({nen, sel2, sel1})

endmodule
