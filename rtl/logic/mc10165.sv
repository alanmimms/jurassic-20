module mc10165(input bit d0,d1,d2,d3,d4,d5,d6,d7,
	       hold,
	       output bit any, q4, q2, q1);

  always_latch

    if (hold) begin
      priority case ({d0,d1,d2,d3,d4,d5,d6,d7})
	0: {q4,q2,q1} = 0;
	1: {q4,q2,q1} = 1;
	2: {q4,q2,q1} = 2;
	3: {q4,q2,q1} = 3;
	4: {q4,q2,q1} = 4;
	5: {q4,q2,q1} = 5;
	6: {q4,q2,q1} = 6;
	7: {q4,q2,q1} = 7;
      endcase // priority case ({d0,d1,d2,d3,d4,d5,d6,d7})

      any = !|{d0,d1,d2,d3,d4,d5,d6,d7};
    end

endmodule
