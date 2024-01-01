`include "logic.svh"

// This is like MC10141 ECL universal shift register
module mc10141(input bit shft0in,
               input bit d0, d1, d2, d3,
               input bit shft3in,
               input bit op2, op1,
               input bit clk,
               output bit q0, q1, q2, q3);
  bit [0:3] value;

  always_comb {q0,q1,q2,q3} = value;

  always_ff @(posedge clk) begin

    unique case (tMode141'({op2, op1}))
      LOAD:   value <= {d0,d1,d2,d3};
      SHIFTR: value <= {value[1:3], shft3in};
      SHIFTL: value <= {shft0in, value[0:2]};
      HOLD:   ;
    endcase

    if ($sformatf("%m") == "top.kl10pv.clk_32.e12")
      $fdisplay(feSim.dumpFD, "%7.3f %m posedge clk value=%b", $realtime, value);
  end

  always_ff @(negedge clk) begin
    if ($sformatf("%m") == "top.kl10pv.clk_32.e12")
      $fdisplay(feSim.dumpFD, "%7.3f %m negedge clk value=%b", $realtime, value);
  end

endmodule
