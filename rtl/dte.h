
typedef enum {
  dteNone,
  dteDiagFunc,
  dteRead,
  dteWrite,
  dteMisc,
  dteReleaseEBUSData
} tReqType;

static const char *reqTypeNames[] = {
  "dteNone",
  "dteDiagFunc",
  "dteRead",
  "dteWrite",
  "dteMisc",
  "dteReleaseEBUSData"
};


typedef enum {
  clrCROBAR,
  getAPRID,
  writeMemory,
  readMemory,
  getDiagWord1,
  loadAR,
  resetCRA
} tMiscFuncType;

static const char *miscFuncNames[] = {
  "clrCROBAR",
  "getAPRID",
  "writeMemory",
  "readMemory",
  "getDiagWord1",
  "loadAR",
  "resetCRA"
};


typedef enum {
  diagfSTOP_CLOCK = 0000,
  diagfSTART_CLOCK = 0001,
  diagfSTEP_CLOCK = 0002,
  diagfCOND_STEP = 0004,
  diagfBURST = 0005,
  diagfCLR_RESET = 0006,
  diagfSET_RESET = 0007,
  diagfCLR_RUN = 0010,
  diagfSET_RUN = 0011,
  diagfCONTINUE = 0012,
  diagfCLR_BURST_CTR_RH = 0042,
  diagfCLR_BURST_CTR_LH = 0043,
  diagfCLR_CLK_SRC_RATE = 0044,
  diagfSET_EBOX_CLK_DISABLES = 0045,
  diagfRESET_PAR_REGS = 0046,
  diagfCLR_MBOXDIS_PARCHK_ERRSTOP = 0047,
  diagfCLR_CRAM_DIAG_ADR_RH = 0051,
  diagfCLR_CRAM_DIAG_ADR_LH = 0052,
  diagfENABLE_KL = 0067,
  diagfINIT_CHANNELS = 0070,
  diagfWRITE_MBOX = 0071,
  diagfEBUS_LOAD = 0076,
  diagfIdle = 0077
} tDiagFunction;

static const char *diagFuncNames[] = {
    /* 000 */ "diagfSTOP_CLOCK",
    /* 001 */ "diagfSTART_CLOCK",
    /* 002 */ "diagfSTEP_CLOCK",
    /* 003 */ "???diagf003???",
    /* 004 */ "diagfCOND_STEP",
    /* 005 */ "diagfBURST",
    /* 006 */ "diagfCLR_RESET",
    /* 007 */ "diagfSET_RESET",
    /* 010 */ "diagfCLR_RUN",
    /* 011 */ "diagfSET_RUN",
    /* 012 */ "diagfCONTINUE",
    /* 013 */ "???diagf013???",
    /* 014 */ "???diagf014???",
    /* 015 */ "???diagf015???",
    /* 016 */ "???diagf016???",
    /* 017 */ "???diagf017???",
    /* 020 */ "???diagf020???",
    /* 021 */ "???diagf021???",
    /* 022 */ "???diagf022???",
    /* 023 */ "???diagf023???",
    /* 024 */ "???diagf024???",
    /* 025 */ "???diagf025???",
    /* 026 */ "???diagf026???",
    /* 027 */ "???diagf027???",
    /* 030 */ "???diagf030???",
    /* 031 */ "???diagf031???",
    /* 032 */ "???diagf032???",
    /* 033 */ "???diagf033???",
    /* 034 */ "???diagf034???",
    /* 035 */ "???diagf035???",
    /* 036 */ "???diagf036???",
    /* 037 */ "???diagf037???",
    /* 040 */ "???diagf040???",
    /* 041 */ "???diagf041???",
    /* 042 */ "diagfCLR_BURST_CTR_RH",
    /* 043 */ "diagfCLR_BURST_CTR_LH",
    /* 044 */ "diagfCLR_CLK_SRC_RATE",
    /* 045 */ "diagfSET_EBOX_CLK_DISABLES",
    /* 046 */ "diagfRESET_PAR_REGS",
    /* 047 */ "diagfCLR_MBOXDIS_PARCHK_ERRSTOP",
    /* 050 */ "???diagf050???",
    /* 051 */ "diagfCLR_CRAM_DIAG_ADR_RH",
    /* 052 */ "diagfCLR_CRAM_DIAG_ADR_LH",
    /* 053 */ "???diagf053???",
    /* 054 */ "???diagf054???",
    /* 055 */ "???diagf055???",
    /* 056 */ "???diagf056???",
    /* 057 */ "???diagf057???",
    /* 060 */ "???diagf060???",
    /* 061 */ "???diagf061???",
    /* 062 */ "???diagf062???",
    /* 063 */ "???diagf063???",
    /* 064 */ "???diagf064???",
    /* 065 */ "???diagf065???",
    /* 066 */ "???diagf066???",
    /* 067 */ "diagfENABLE_KL",
    /* 070 */ "diagfINIT_CHANNELS",
    /* 071 */ "diagfWRITE_MBOX",
    /* 072 */ "???diagf072???",
    /* 073 */ "???diagf073???",
    /* 074 */ "???diagf074???",
    /* 075 */ "???diagf075???",
    /* 076 */ "diagfEBUS_LOAD",
    /* 077 */ "diagfIdle"
};
