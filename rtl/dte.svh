
`ifndef __DTE_SVH__
`define __DTE_SVH__ 1
typedef enum {
  dteNone,
  dteDiagFunc,
  dteRead,
  dteWrite,
  dteMisc,
  dteReleaseEBUSData
} tReqType;

typedef enum {
  clrCROBAR,
  getAPRID,
  writeMemory,
  readMemory,
  getDiagWord1,
  loadAR,
  resetCRA
} tMiscFuncType;

typedef enum bit [0:6] {
  diagfSTOP_CLOCK = 7'o000,
  diagfSTART_CLOCK = 7'o001,
  diagfSTEP_CLOCK = 7'o002,
  diagfCOND_STEP = 7'o004,
  diagfBURST = 7'o005,
  diagfCLR_RESET = 7'o006,
  diagfSET_RESET = 7'o007,
  diagfCLR_RUN = 7'o010,
  diagfSET_RUN = 7'o011,
  diagfCONTINUE = 7'o012,
  diagfCLR_BURST_CTR_RH = 7'o042,
  diagfCLR_BURST_CTR_LH = 7'o043,
  diagfCLR_CLK_SRC_RATE = 7'o044,
  diagfSET_EBOX_CLK_DISABLES = 7'o045,
  diagfRESET_PAR_REGS = 7'o046,
  diagfCLR_MBOXDIS_PARCHK_ERRSTOP = 7'o047,
  diagfCLR_CRAM_DIAG_ADR_RH = 7'o051,
  diagfCLR_CRAM_DIAG_ADR_LH = 7'o052,
  diagfENABLE_KL = 7'o067,
  diagfINIT_CHANNELS = 7'o070,
  diagfWRITE_MBOX = 7'o071,
  diagfEBUS_LOAD = 7'o076,
  diagfIdle = 7'o077
} tDiagFunction;
`endif
