module mc10173(input bit d00,d10,d20,d30, d01,d11,d21,d31,
	       sel, nen,
	       output bit b0,b1,b2,b3);

  bit [3:0] curState;
  bit [3:0] selState;

  always_ff @(nen) curState = sel ? {d00,d10,d20,d30} : {d01,d11,d21,d31};
  always_comb selState = sel ? {d00,d10,d20,d30} : {d01,d11,d21,d31};
  always_comb {b0,b1,b2,b3} = nen ? curState : selState;

endmodule
