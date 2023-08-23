module mc10173(input bit d00,d01,d02,d03, d10,d11,d12,d13,
	       sel, nen,
	       output bit b0,b1,b2,b3);

  always_latch

    if (!nen) begin
      {b0,b1,b2,b3} = sel ? {d10,d11,d12,d13} : {d00,d01,d02,d03};
    end

endmodule
