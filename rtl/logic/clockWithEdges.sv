// Generate a clock whose posedge is `edge1` and whose negedge is `edge2`.
module clockWithEdges(input bit edge1, edge2,
		      output bit q);

  always_ff @(posedge edge1, posedge edge2) q <= edge1;
endmodule
