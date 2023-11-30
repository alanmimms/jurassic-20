module mc10173(input bit d00,d10,d20,d30, d01,d11,d21,d31, sel, nen,
	       output bit b0,b1,b2,b3);

  /* verilator lint_off NOLATCH */
  // I tried MIGHTILY to get Verilator to shut up about "no latch"
  // warnings here, but to no avail.
  always_latch
    if (!nen) {b0,b1,b2,b3} = !sel ? {d00,d10,d20,d30} : {d01,d11,d21,d31};

endmodule
