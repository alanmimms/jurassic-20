module mc10174(input bit d00,d01,d02,d03, d10,d11,d12,d13,
	       sel2,sel1, nen,
	       output bit b0,b1);

  always_comb begin

    if (!nen) begin

      unique case ({sel2, sel1})
	2'b00: b0 = d00;
	2'b01: b0 = d01;
	2'b10: b0 = d02;
	2'b11: b0 = d03;
      endcase

      unique case ({sel2, sel1})
	2'b00: b1 = d10;
	2'b01: b1 = d11;
	2'b10: b1 = d12;
	2'b11: b1 = d13;
      endcase
    end else
      {b0,b1} = 0;

  end
endmodule
