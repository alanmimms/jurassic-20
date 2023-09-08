`ifndef _KL10PV_SVH_
 `define _KL10PV_SVH_ 1

 `include "dte.svh"

typedef bit [35:0] W36;

///////////////////////////////////////////////////////////////
// EBUS

// Each driver of EBUS gets its own instance of this. These are all
// muxed onto the EBUS.data member based on the one-hot
// tEBUSdriver.driving indicator.

typedef struct packed {
  bit [0:35] data;
  bit driving;
} tEBUSdriver;

typedef enum bit [0:2] {
  ebusfCONO = 3'b000,
  ebusfCONI = 3'b001,
  ebusfDATAO = 3'b010,
  ebusfDATAI = 3'b011,
  ebusfPIserved = 3'b100,
  ebusfPIaddrIn = 3'b101
} tEBUSfunction;

interface iEBUS;
  bit [0:35] data;            // Driven by EBUS mux
  bit parity;                 // Parity for what exactly? XXX
  bit [0:6] cs;               // EBOX -> dev Controller select
  tEBUSfunction func;           // EBOX -> dev Function
  bit demand;                 // EBOX -> dev
  bit [0:7] pi;               // Dev -> EBOX Priority Interrupt
  bit ack;                    // Dev -> EBOX acknowledge
  bit xfer;                   // Dev -> EBOX transfer done
  bit reset;                  // EBOX -> dev
  tDiagFunction ds;           // DTE -> EBOX Diagnostic Select
  bit diagStrobe;             // DTE -> EBOX Diagnostic strobe
  bit dfunc;                  // Dev -> EBOX Diagnostic function
endinterface;

`endif //  `ifndef _KL10PV_SVH_
