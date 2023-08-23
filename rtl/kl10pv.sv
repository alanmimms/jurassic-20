// The top of the hierarchy for KL10PV CPU and its front end, memory,
// peripherals, and power system.
module kl10pv(input clk60, crobar);

`include "kl-backplane.svh"

   assign crobar_e_h = crobar;

endmodule // kl10pv
