`ifndef _KL10PV_SVH_
 `define _KL10PV_SVH_ 1

 `include "dte.svh"

typedef bit [0:85] tCRAM;
typedef bit [0:10] tCRAMAddress;

typedef bit [0:35] W36;
typedef bit [15:0] W16;

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


////////////////////////////////////////////////////////////////
// The internal memory bus, which is the ECL side of the M8519-0-MT01
// "INTERNAL MEMORY BUS TRANSLATOR" starting on PDF96. The SBUS cable
// side of this translator is actually not present in this
// design. Instead, this iMBUS is the interface to our memory
// implementation.
//
// The mbox modport is the one we attach to the MBOX modules. The
// memory modport is what we implement for our memory. Note that we
// translate to active high signaling and camelCase signal names
// through this interface to make things simpler.
interface iMBUS;
  bit clk;			// From MBOX to memory
  bit diag;			// From MBOX to memory
  bit error;			// From memory to MBOX
  bit memReset;			// From MBOX to memory

  bit adrHold;			// From MBOX to memory
  bit [14:35] adr;		// From MBOX to memory
  bit adrPar;			// From memory to MBOX
  bit adrParErr;		// From memory to MBOX

  bit acknA, acknB;		// From memory to MBOX
  bit outValidA, outValidB;	// From memory to MBOX
  bit inValidA, inValidB;	// From MBOX to memory
  bit startA, startB;		// From MBOX to memory

  W36 dIn;			// From memory to MBOX
  bit parIn;			// From memory to MBOX
  W36 dOut;			// From MBOX to memory
  bit parOut;			// From MBOX to memory

  bit rdRq;			// From MBOX to memory
  bit wrRq;			// From MBOX to memory
  bit [0:3] rq;			// From MBOX to memory

  modport mbox(
               output clk,
               output diag,
               input error,
               output memReset,

	       output adrHold,
               output adr, adrPar, adrParErr,

               input acknA, acknB,
               output outValidA, outValidB,
               input inValidA, inValidB,
               output startA, startB,

	       input dIn, parIn,
               output dOut, parOut,

               output rdRq, wrRq,
               output rq
               );

  modport memory(
		 input clk,
		 input diag,
		 output error,
		 input memReset,

		 input adrHold,
		 input adr, adrPar, adrParErr,

		 output acknA, acknB,
		 input outValidA, outValidB,
		 output inValidA, inValidB,
		 input startA, startB,

		 output dIn, parIn,
		 input dOut, parOut,

		 input rdRq, wrRq,
		 input rq
                 );
endinterface

`endif //  `ifndef _KL10PV_SVH_
