module seq #(parameter N=4)
  (input bit clk,
   input bit reset,
   output bit [N-1:0] q
   );

  bit [12:35] addr;             // Address base we start at for quadword
  bit [34:35] wo;               // Word offset of quadword
  bit [0:3] toAck;              // Words we have not yet ACKed

  assign ACKN = toAck[0];
  assign VALID = toAck[0];

  always_comb if (VALID) begin
    D = memory[{addr[12:33], wo}];
    PARITY = ^memory[{addr[12:33], wo}];
  end else begin
    D = '0;
    PARITY = 0;
  end

  always_ff @(posedge clk) if (CROBAR) begin
    addr <= '0;
    wo <= '0;
    toAck <= '0;
  end else if (START) begin     // A transfer is starting or continuing
    addr <= SBUS.ADR;           // Address of first word we do
    wo <= SBUS.ADR[34:35];      // Word offset we increment mod 4
    toAck <= SBUS.RQ;           // Addresses remaining to ACK
  end

  always_ff @(posedge clk) if (toAck) begin
    wo <= wo + 1;
    toAck <= toAck << 1;
  end
endmodule
