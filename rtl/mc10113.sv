// Quad XOR with enable
module mc10113(input bit a1, a2, b1, b2, c1, c2, d1, d2, ne,
	       output bit qa, qb, qc, qd);
   
   always_comb begin

      if (!ne) begin
	 qa = a1 ^ a2;
	 qb = b1 ^ b2;
	 qc = c1 ^ c2;
	 qd = d1 ^ d2;
      end else begin
	 qa = '0;
	 qb = '0;
	 qc = '0;
	 qd = '0;
      end
   end

endmodule // mc10113
