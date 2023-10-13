module mc10176(input bit d0,d1,d2,d3,d4,d5, clk,
	       output bit q0,q1,q2,q3,q4,q5);
  bit [0:5] d, q, mid;

  always_comb begin
    d = {d0,d1,d2,d3,d4,d5};
    {q0,q1,q2,q3,q4,q5} = q;
  end

  dff m[0:5] (.d(d), .clk(!clk), .q(mid));
  dff s[0:5] (.d(mid), .clk(clk), .q(q));
endmodule // mc10176


module dff(input bit d, clk, output bit q);
  always @(posedge clk) q <= d;
endmodule // dff
