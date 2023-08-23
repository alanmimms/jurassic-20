module mc10147(input bit a0, a1, a2, a3, a4, a5, a6,
	       input bit d, nen1, nen2, nwrite,
	       output bit q);

  bit ram[127:0];
  bit we = !nen1 && !nen2 && !nwrite;
  bit re = !nen1 && !nen2 && nwrite;
  bit [6:0] addr = {a0,a1,a2,a3,a4,a5,a6};

  always_ff @(posedge re, posedge we) begin

    if (re) ram[addr] <= d;
    else if (we) q <= ram[addr];
    else q <= '0;
  end
endmodule
