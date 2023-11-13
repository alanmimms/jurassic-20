module mc10165(input bit d0,d1,d2,d3,d4,d5,d6,d7,
	       hold,
	       output bit any, q4, q2, q1);

  always_comb any = d0 | d1 | d2 | d3 | d4 | d5 | d6 | d7;

  always_latch

    if (!hold) begin
           if (d0) {q4,q2,q1} = 0;
      else if (d1) {q4,q2,q1} = 1;
      else if (d2) {q4,q2,q1} = 2;
      else if (d3) {q4,q2,q1} = 3;
      else if (d4) {q4,q2,q1} = 4;
      else if (d5) {q4,q2,q1} = 5;
      else if (d6) {q4,q2,q1} = 6;
      else if (d7) {q4,q2,q1} = 7;
    end

endmodule
