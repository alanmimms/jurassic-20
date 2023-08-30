module mc10160(input bit d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,
	       output bit odd);

  always_comb odd = ^{d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11};
endmodule
