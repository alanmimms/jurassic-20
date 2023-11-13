module mc10173(input bit d00,d10,d20,d30, d01,d11,d21,d31, sel, nen,
	       output bit b0,b1,b2,b3);
  bit hold = nen;

  always_latch

    if (!hold) begin

      if (sel)
	{b0,b1,b2,b3} = {d01,d11,d21,d31};
      else
	{b0,b1,b2,b3} = {d00,d10,d20,d30};

    end
endmodule
