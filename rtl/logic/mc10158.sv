module mc10158(input bit d00,d01, d10,d11, d20,d21, d30,d31,
	       sel,
	       output bit b0, b1, b2, b3);

  assign {b0,b1,b2,b3} = sel ? {d01,d11,d21,d31} : {d00,d10,d20,d30};
endmodule
