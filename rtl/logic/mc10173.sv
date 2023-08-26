module mc10173(input bit d00,d10,d20,d30, d01,d11,d21,d31,
	       sel, nen,
	       output bit b0,b1,b2,b3);

  always_latch

    if (!nen) begin
      {b0,b1,b2,b3} = sel ? {d01,d11,d21,d31} : {d00,d10,d20,d30};
    end

endmodule
