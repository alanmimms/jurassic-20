module mc10173(input bit d00,d10,d20,d30, d01,d11,d21,d31, sel, nen,
	       output bit b0,b1,b2,b3);

  /* verilator lint_off NOLATCH */
  // I tried MIGHTILY to get Verilator to shut up about "no latch"
  // warnings here, but to no avail.
  always_latch @(nen or sel) if (!nen) b0 = !sel ? d00 : d01;
  always_latch @(nen or sel) if (!nen) b1 = !sel ? d10 : d11;
  always_latch @(nen or sel) if (!nen) b2 = !sel ? d20 : d21;
  always_latch @(nen or sel) if (!nen) b3 = !sel ? d30 : d31;
endmodule
