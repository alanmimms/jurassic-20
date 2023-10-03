// The FE protocol is communicated via shared memory form from the
// fork to this same code running in Verilator simulation process.
// Every message FE->TB and TB->FE is tPipeRequest.
//
// Time in measured in terms of 10/11 clocks - 60ns per tick. The
// request time specifies the ticks count to do the action or is zero
// for asynchronous (do it NOW) operations.
//
// Where `type` is one of the operations below and ARGS is the list of
// space separated parameters needed by the operation. Each operation
// excutes at the constrained time and the result of the operation is
// sent as a reply in format shown in the next section.
//
// * dteDiagFunc
//   Do an EBUS DS diagnostic function with DIAG on EBUS.DS.
//
// * dteRead
//   Do an EBUS DS diagnostic function with DIAG on EBUS.DS and return
//   the resulting EBUS.data as part of the reply.
//
// * dteWrite
//   Do an EBUS DS diagnostic write with DIAG on EBUS.DS and EBUS-DATA
//   on EBUS.data.
//
// Every operation returns a reply TB->FE tPipeRequest.
//
// Where `time` is the tick count of when the operation actually
// executed.
//
// Where `type` is the operation type this reply is associated with.

// Where `data` is the EBUS data value returned after the operation.
#define _GNU_SOURCE 1

#include <sys/types.h>
#include <sys/select.h>
#include <sys/prctl.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <svdpi.h>
#include <math.h>

static const int feVerbose = 1;  /* Show FE progress */
static const int regVerbose = 0; /* Show register operations */
static const int pipeVerbose = 0;   /* Show pipe messages */

// Probably we are building 64-bit anyway, but this emphasizes the
// point. These are 64-bit typedefs.
typedef unsigned long long W36;

typedef unsigned long long LL;           /* For ticks values from Verilator */


// Halfword mask
static const LL HALF = 0777777LL;


// PDP10 bit constants
static const W36 B0  = 1ull << (35 - 0);
static const W36 B1  = 1ull << (35 - 1);
static const W36 B2  = 1ull << (35 - 2);
static const W36 B3  = 1ull << (35 - 3);
static const W36 B4  = 1ull << (35 - 4);
static const W36 B5  = 1ull << (35 - 5);
static const W36 B6  = 1ull << (35 - 6);
static const W36 B7  = 1ull << (35 - 7);
static const W36 B8  = 1ull << (35 - 8);
static const W36 B9  = 1ull << (35 - 9);
static const W36 B10 = 1ull << (35 - 10);
static const W36 B11 = 1ull << (35 - 11);
static const W36 B12 = 1ull << (35 - 12);
static const W36 B13 = 1ull << (35 - 13);
static const W36 B14 = 1ull << (35 - 14);
static const W36 B15 = 1ull << (35 - 15);
static const W36 B16 = 1ull << (35 - 16);
static const W36 B17 = 1ull << (35 - 17);

static const W36 B18 = 1ull << (35 - 18);
static const W36 B19 = 1ull << (35 - 19);
static const W36 B20 = 1ull << (35 - 20);
static const W36 B21 = 1ull << (35 - 21);
static const W36 B22 = 1ull << (35 - 22);
static const W36 B23 = 1ull << (35 - 23);
static const W36 B24 = 1ull << (35 - 24);
static const W36 B25 = 1ull << (35 - 25);
static const W36 B26 = 1ull << (35 - 26);
static const W36 B27 = 1ull << (35 - 27);
static const W36 B28 = 1ull << (35 - 28);
static const W36 B29 = 1ull << (35 - 29);
static const W36 B30 = 1ull << (35 - 30);
static const W36 B31 = 1ull << (35 - 31);
static const W36 B32 = 1ull << (35 - 32);
static const W36 B33 = 1ull << (35 - 33);
static const W36 B34 = 1ull << (35 - 34);
static const W36 B35 = 1ull << (35 - 35);


// Number of DTE clock ticks to leave a diag function asserted
#define DIAG_DURATION   10


// To be clear: "toDTE" is from the fork running from here to
// communicate BACK TO the simulated DTE20 hardware in the Verilator
// simulation process. "toFE" is to allow the simulator to communicate
// to this fork (the "front end" or FE).
// Recall that [0] is the read end of the pipe, [1] is the write end.
static int toDTE[2], toFE[2];
static pid_t fePID;

static W36 firstInsn;


#include "dte.h"

// Struct used to make a request from FE to DTE on the pipe.
struct tPipeRequest {
  LL time;
  tReqType type;
  unsigned short diag;
  W36 data1;
  W36 data2;
};

// Struct used to reply from DTE to FE on the pipe.
struct tPipeReply {
  LL time;
  unsigned long lh;
  unsigned long rh;
};

// Only one request can be outstanding at one time. The ticks value at
// which it should execute is `nextReqTicks`.
static LL nextReqTicks = 0;            /* Ticks count to do next request */

static double nsPerClock;       /* Nanoseconds in each of our ticks */

static W36 bootAddr;



#define TLOG(FMT, ...) do {                                      \
  printf("%6lld: " FMT, nextReqTicks __VA_OPT__(,) __VA_ARGS__); \
} while (0)


#define RLOG(...) do {                \
if (pipeVerbose) printf(__VA_ARGS__); \
} while (0)


#define WLOG(...) do {                \
if (pipeVerbose) printf(__VA_ARGS__); \
} while (0)

#define FELOG(...) do {			\
    if (feVerbose) printf(__VA_ARGS__);   \
} while (0)

#define REGLOG(...) do {             \
if (regVerbose) printf(__VA_ARGS__); \
} while (0)


static void fatalError(const char *msgP) {
  perror(msgP);
  exit(-1);
}


static W36 LH(LL w) {
  return (w >> 18) & HALF;
}


static W36 RH(LL w) {
  return w & HALF;
}


static char octWbuf[64];

static char *octW(LL w, char *buf = octWbuf) {
  sprintf(buf, "%06llo,,%06llo", LH(w), RH(w));
  return buf;
}


static const char *pipeN(int fd) {
  if (fd == toDTE[0]) return "fromFE";
  else if (fd == toDTE[1]) return "toDTE";
  else if (fd == toFE[0]) return "fromDTE";
  else if (fd == toFE[1]) return "toFE";
  else return "???";
}


static W36 sendAndGetResult(LL aTicks,
                            LL duration,
                            tReqType aType,
                            int aDiag = 0,
                            W36 aData1 = 0,
                            W36 aData2 = 0) {
  tPipeRequest req;
  req.time = aTicks;
  req.type = aType;
  req.diag = aDiag;
  req.data1 = aData1;
  req.data2 = aData2;
  WLOG("F write(%s) %ld bytes\n", pipeN(toDTE[1]), sizeof(req));
  int len = write(toDTE[1], &req, sizeof(req));
  if (len < sizeof(req)) fatalError("write to DTE pipe");
  char octWbuf2[32];
  WLOG("F %lld: send %s %s %s %s\n",
       req.time, reqTypeNames[aType],
       aType == dteMisc ? miscFuncNames[aDiag] : diagFuncNames[aDiag],
       octW(aData1), octW(aData2, octWbuf2));

  tPipeReply reply;
  RLOG("F read(%s) %ld bytes\n", pipeN(toFE[0]), sizeof(reply));
  len = read(toFE[0], &reply, sizeof(reply));
  if (len < sizeof(reply)) fatalError("read from DTE pipe");

  LL result = ((LL) reply.lh << 18) | reply.rh;
  REGLOG("F %lld: reply received from DTE: %06lo,,%06lo  result=%llo\n",
         nextReqTicks + reply.time, reply.lh, reply.rh, result);
  nextReqTicks += duration;
  return result;
}


//   Do an EBUS DS diagnostic write with DIAG on EBUS.DS and EBUS-DATA
//   on EBUS.data.
static void doWrite(int func, W36 value) {
  REGLOG("F diag write %s %s\n", diagFuncNames[func], octW(value));
  sendAndGetResult(nextReqTicks, DIAG_DURATION, dteWrite, func, value);
  sendAndGetResult(nextReqTicks, 1, dteReleaseEBUSData);
}


//   Do a miscellaneous control function in DTE and return (optional) result.
static W36 doMiscFunc(int func, W36 data1 = 0, W36 data2 = 0) {
  REGLOG("F misc func %s\n", miscFuncNames[func]);
  return sendAndGetResult(nextReqTicks, 1, dteMisc, func, data1, data2);
}


static W36 doWriteMemory(W36 addr, W36 w) {
  REGLOG("F write memory [%08llo]=%s\n", addr, octW(w));
  return sendAndGetResult(nextReqTicks, 1, dteMisc, writeMemory, addr, w);
}


static W36 doReadMemory(W36 addr) {
  REGLOG("F read memory [%6llo]\n", addr);
  return sendAndGetResult(nextReqTicks, 1, dteMisc, readMemory, addr);
}


//   Do an EBUS DS diagnostic function with DIAG on EBUS.DS.
static void doDiagFunc(int func) {
  REGLOG("F diag func %s\n", diagFuncNames[func]);
  sendAndGetResult(nextReqTicks, DIAG_DURATION, dteDiagFunc, func);
  sendAndGetResult(nextReqTicks, 1, dteReleaseEBUSData);
}


//   Do an EBUS DS diagnostic function with DIAG on EBUS.DS and return
//   the resulting EBUS.data as part of the reply.
static W36 doRead(int func) {
  //  REGLOG("F diag func %s\n", diagFuncNames[func]);

  /* Send function and delay 1us until EBUS.data is stable */
  sendAndGetResult(nextReqTicks, (LL) ceil(1000.0 / nsPerClock), dteDiagFunc, func);

  REGLOG("F diag %s read\n", diagFuncNames[func]);
  W36 result = sendAndGetResult(nextReqTicks, DIAG_DURATION, dteRead);
  REGLOG("      result=%s\n", octW(result));
  sendAndGetResult(nextReqTicks, 1, dteReleaseEBUSData);
  return result;
}


static void waitFor(LL ticks) {
  REGLOG("F %lld: wait %lld ticks until %lld\n", nextReqTicks, ticks, nextReqTicks + ticks);
  nextReqTicks += ticks;
}


static W36 fileWordToWord(unsigned char fw[]) {
  return
    ((W36) fw[0] << 28) |
    ((W36) fw[1] << 20) |
    ((W36) fw[2] << 12) |
    ((W36) fw[3] <<  4) |
    (W36) fw[4];
}


// Load the BOOT.EXE into memory and return the boot address.
#define IMAGE "./images/aboot/boot.exe"
static W36 loadBootstrap(W36 *firstInsnP) {
  LL startTicks = nextReqTicks;
  printf("\n");
  TLOG("[Loading BOOT.EXE]\n");

  FILE *memLogF = fopen("mem.log", "w");

  FILE *f = fopen(IMAGE, "rb");
  if (!f) fatalError("opening " IMAGE);
  W36 minAddr = (1ull << 36) - 1;
  W36 maxAddr = 0;
  W36 w;

  for (;;) {
    unsigned char fw[5];
    size_t len = fread(&fw, 1, sizeof(fw), f);
    if (len < sizeof(fw)) fatalError("reading " IMAGE);
    w = fileWordToWord(fw);
    unsigned nww = LH(w);
    unsigned addr = RH(w);
    if (nww < B18) break;

    int nWords = B17 - nww;     /* Negate RH */

    for (int wn = nWords; wn; --wn) {
      ++addr;                   /* CSAV format provides addr-1, so preincrement */
      len = fread(fw, 1, sizeof(fw), f);
      if (len < sizeof(fw)) fatalError("reading " IMAGE);
      w = fileWordToWord(fw);
      if (addr < minAddr) minAddr = addr;
      if (addr > maxAddr) maxAddr = addr;
      if (addr == 040000ull) *firstInsnP = w; /* HACK XXX */
      doWriteMemory(addr, w);
      fprintf(memLogF, "%06o: %s\n", addr, octW(w));
    }
  }

  TLOG("[loaded in %lld ticks]\n", nextReqTicks - startTicks);
  printf("          [boot image minAddr: %6llo]\n", minAddr);
  printf("          [boot image maxAddr: %6llo]\n", maxAddr);

  doWriteMemory(0ull, w);
  fprintf(memLogF, "%06o: %s\n", 0u, octW(w));
  TLOG("[start instruction %s deposited in mem[0]]\n", octW(w));
  fclose(f);
  fclose(memLogF);
  return w;
}


static void klReset() {
  TLOG("[KL reset]\n");

  // $DFXC(.CLRUN=010)    ; Clear run
  FELOG("[clear RUN flop]\n");
  doDiagFunc(diagfCLR_RUN);

  bootAddr = loadBootstrap(&firstInsn);

  // This is the first phase of DMRMRT table operations.
  FELOG("[clear clock source rate]\n");
  doWrite(diagfCLK_SRC_RATE, 0);
  FELOG("[stop clocks]\n");
  doDiagFunc(diagfSTOP_CLOCK);
  FELOG("[set reset]\n");
  doDiagFunc(diagfSET_RESET);
  FELOG("[reset parity registers]\n");
  doWrite(diagfRESET_PAR_REGS, 0);
  FELOG("[clear MBOX parity checkstops]\n");
  doWrite(diagfMBOXDIS_PARCHK_ERRSTOP, 0);
  FELOG("[clear EBOX parity checkstops]\n");
  doWrite(diagfRESET_PAR_REGS, 0);
                                                  // PARITY CHECK, ERROR STOP ENABLE
  FELOG("[clear clock burst counter RH]\n");
  doWrite(diagfBURST_CTR_RH, 0);          // LOAD BURST COUNTER (8,4,2,1)
  FELOG("[clear clock burst counter LH]\n");
  doWrite(diagfBURST_CTR_LH, 0);          // LOAD BURST COUNTER (128,64,32,16)
  FELOG("[load EBOX clock disable]\n");
  doWrite(diagfSET_EBOX_CLK_DISABLES, 0);     // LOAD EBOX CLOCK DISABLE
  FELOG("[start clock]\n");
  doDiagFunc(diagfSTART_CLOCK);                   // START THE CLOCK
  FELOG("[init channels]\n");
  doWrite(diagfINIT_CHANNELS, 0);             // INIT CHANNELS
  FELOG("[clear clock burst counter RH]\n");
  doWrite(diagfBURST_CTR_RH, 0);          // LOAD BURST COUNTER (8,4,2,1)

  // Loop up to three times:
  //   Do diag function 162 via $DFRD test (A CHANGE COMING A L)=EBUS[32]
  //   If not set, $DFXC(.SSCLK=002) to single step the MBOX
  FELOG("[step up to 5 clocks to synchronize MBOX]\n");
  bool mboxInitSuccess = false;

  for (int k = 0; k < 5; ++k) {
    waitFor(8);
    FELOG("[read EBUS 0162]\n");

    if ((doRead(0162) & B32) == 0) {
      FELOG("[success]\n");
      mboxInitSuccess = true;
      break;
    }

    waitFor(8);
    FELOG("[step clock]\n");
    doDiagFunc(diagfSTEP_CLOCK);
  }

  if (!mboxInitSuccess) TLOG("[WARNING: MBOX initialization (A CHANGE COMING L) failed]\n");
  
  // Phase 2 from DMRMRT table operations.
  FELOG("[conditional single step]\n");
  doDiagFunc(diagfCOND_STEP);             // CONDITIONAL SINGLE STEP
  FELOG("[clear reset]\n");
  doDiagFunc(diagfCLR_RESET);             // CLEAR RESET
  FELOG("[enable KL instruction decode and ACs]\n");
  doWrite(diagfENABLE_KL, 0);             // ENABLE KL STL DECODING OF CODES & AC'S
  FELOG("[reset MBOX]\n");
  doWrite(diagfEBUS_LOAD, 0);             // SET KL10 MEM RESET FLOP
  doWrite(diagfWRITE_MBOX, 0120);         // WRITE M-BOX
  TLOG("[KL reset complete t=%lld]\n\n", nextReqTicks);
}


// Derived from KLINIT.T20 $TENST and $STRKL functions. XXX for now,
// use all zero (which is already loaded to AC0 by clearing all ACs)
// for .KLIWD to indicate we want dialog with KL boot process.
//
// $STRKL: START THE KL AT THE 22 BIT ADDRESS POINTED TO BY R0. THIS
// IS DONE BY LOADING THE AR WITH THE ADDRESS, PUSHING THE RUN AND
// CONTINUE BUTTONS, AND STARTING THE CLOCK. WE STEP THE MICROCODE OUT
// OF THE HALT LOOP TO MAKE SURE IT IS RUNNING BEFORE WE LEAVE.
static void startKL(W36 bootAddr) {
  bootAddr &= (1ul << 23) - 1ul; /* Mask to just 22 bits of start address */

  // Load bootAddr into AR. Based on KLINIT.T20 $LDAR routine. PUT THE
  // MICROCODE INTO THE HALT LOOP, STOP IT, PHASE THE CLOCKS, AND LOAD
  // THE AR REGISTER WITH AN INSTRUCTION OR STARTING ADDRESS.
  //
  // We can actually assume we are already in the HALT loop and stopped.
  // So we don't bother with the clock phasing shit. We just stop the KL
  // clock, load AR with our starting PC, and let the HALT loop exit
  // process reset the CRADR to zero (the START entry point).
  // This differs from DTE20 FE but its end effect is the same.
  char firstInsnBuf[64];
  TLOG("[load AR with %s = %s]\n", octW(bootAddr), octW(firstInsn, firstInsnBuf));
  doMiscFunc(loadAR, LH(bootAddr), RH(bootAddr));
  waitFor(50);

  // Set the RUN flop.
  FELOG("[set RUN flop]\n");
  doDiagFunc(diagfSET_RUN);

  // Push the CONTINUE button.
  FELOG("[set CONTINUE]\n");
  doDiagFunc(diagfCONTINUE);

  // Single step the MBOX clock up to 1000 times waiting for
  // indication the KL microcode is out of its HALT loop by checking
  // for RUN being set in its status.
  int nStepsToRUN = 1000;

  while (--nStepsToRUN) {
    doDiagFunc(diagfSTEP_CLOCK);
    W36 diag1 = doMiscFunc(getDiagWord1);
    if ((diag1 & 1) == 0) break;       /* HALT flag is clear */
  }

  if (!nStepsToRUN) TLOG("WARNING: KL didn't exit HALT loop after 1000 clocks\n");

  // Start the KL clock running.
  FELOG("[start KL clock t=%lld]\n", nextReqTicks);
  doDiagFunc(diagfSTART_CLOCK);                   // START THE CLOCK
}


static void klBoot(void) {
  printf("\nKLISIM -- VERSION 0.0.1 RUNNING\n");

  // LQSHDO: Get hardware options from RH(APRID)
  const W36 aprid = doMiscFunc(getAPRID);
  const unsigned ucodeVersion = LH(aprid);
  const unsigned ucodeMajor = ucodeVersion >> 12;
  const unsigned ucodeMinor = (ucodeVersion >> 9) & 7;
  const unsigned ucodeEdit = ucodeVersion & 0777;
  const unsigned hwo = RH(aprid);
  printf("KLISIM -- KL10 S/N: %0lld., MODEL B, %0d HERTZ\n",
         hwo & (B22 - 1), (hwo & B18) ? 50 : 60);
  printf("KLISIM -- KL10 HARDWARE ENVIRONMENT\n");
  if (hwo & B22) printf("   MOS MASTER OSCILLATOR\n");
  if (hwo & B21) printf("   EXTENDED ADDRESSING\n");
  if (hwo & B20) printf("   INTERNAL CHANNELS\n");
  if (hwo & B19) printf("   CACHE\n");

  printf("\nKLISIM -- MICROCODE VERSION %0o.%0o(%0o) LOADED\n\n",
         ucodeMajor, ucodeMinor, ucodeEdit);

  startKL(bootAddr);
}


static void HUPhandler(int sig) {
  printf("\n[FE process got SIGHUP from parent - exiting]\n");
  exit(-1);
}


static void runFE(void) {
  // Arrange to have our HUP handler called when parent exits
  static const struct sigaction HUPaction = {HUPhandler};

  int st = sigaction(SIGHUP, &HUPaction, 0);
  if (st) fatalError("SIGHUP sigaction");
  
  prctl(PR_SET_PDEATHSIG, SIGHUP);
  
  // Release CROBAR (power on RESET) signal
  waitFor(13);
  doMiscFunc(clrCROBAR);

  klReset();
  klBoot();
  for (;;) waitFor(99999999LL);
}


static int dteReadNFDs;
static fd_set dteReadFDs;


// This function runs in sim context and is called from RTL. Returns
// true if there is a request to do.
extern "C" bool DTErequestIsPending(void) {
  struct timeval justPollTimeVal = {0, 0};
  fd_set fds = dteReadFDs;
  int st = select(dteReadNFDs, &fds, NULL, NULL, &justPollTimeVal);
  if (st < 0) fatalError("DTErequestIsPending select");
  return st != 0 && FD_ISSET(toDTE[0], &fds);
}


// This function runs in sim context and is called from RTL. Only call
// this if `DTErequestIsPending()` returns `true` or you'll block.
extern "C" void DTEgetRequest(LL *reqTimeP, int *reqTypeP, int *diagReqP,
                              LL *reqData1P, LL *reqData2P) {
  // If we get here we have a message in the pipe. Read it.
  tPipeRequest req;
  RLOG("S read(%s) %ld bytes\n", pipeN(toDTE[0]), sizeof(req));
  int st = read(toDTE[0], &req, sizeof(req));
  if (st < 0) fatalError("DTEgetRequest pipe read");
  *reqTimeP = req.time;
  *reqTypeP = (int) req.type;
  *diagReqP = (int) req.diag;
  *reqData1P = req.data1;
  *reqData2P = req.data2;
}


// This function runs in sim context.
extern "C" void DTEreply(LL aReplyTime, int replyLH, int replyRH) {
  struct tPipeReply reply;
  reply.time = aReplyTime;
  reply.lh = replyLH;
  reply.rh = replyRH;
  WLOG("S write(%s) result=%06o,,%06o of %ld bytes\n",
       pipeN(toFE[1]), replyLH, replyRH, sizeof(reply));
  int st = write(toFE[1], &reply, sizeof(reply));
  if (st < 0) fatalError("write toFE");
  //  REGLOG("S %lld: reply sent to FE %s %lld\n",
  //       aReplyTime, reqTypeNames[reply.type], reply.data);
}


extern "C" void FEinitial(double aNsPerClock) {
  int st;

  if (st = pipe2(toDTE, O_DIRECT)) fatalError("Create toDTE pipe");
  if (st = pipe2(toFE, O_DIRECT)) fatalError("Create toFE pipe");

  dteReadNFDs = toDTE[0] + 1;
  FD_SET(toDTE[0], &dteReadFDs);

  nsPerClock = aNsPerClock * 16.0;
  FELOG("[%g ns per DTE clock]\n", nsPerClock);

  pid_t pid = fork();
  if (pid < 0) fatalError("fork FE");

  if (pid == 0) {               /* Running in the child (FE context) */
    runFE();                    /* FE blocks waiting for messages - never returns */
  } else {                      /* Running in the parent (sim context) */
    fePID = pid;                /* Save PID of child */
  }
}


extern "C" void FEfinal(LL ticks) {
  /* Kill our kid */
  if (fePID > 0) kill(fePID, SIGHUP);
}
