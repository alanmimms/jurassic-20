`ifndef _KL10PV_SVH_
 `define _KL10PV_SVH_ 1

// Each driver of EBUS gets its own instance of this. These are all
// muxed onto the iEBUS.data member based on the one-hot
// tEBUSdriver.driving indicator.

typedef struct packed {
  bit [0:35] data;
  bit driving;
} tEBUSdriver;

`endif //  `ifndef _KL10PV_SVH_
