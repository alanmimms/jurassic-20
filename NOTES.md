# TODO:


# Outstanding Questions

* WTF is e.g., `-APR APR PAR CHK EN H\#400\`?
  * What does `\#400\` mean?
  * Clearly the `\` character isn't being used as an escape. It's
    being used as an enclosing pair like brackets.
  * There was some note somewhere that said it was a notation
    selecting a particular type of wire for the signal on the
    backplane? Coax?
  * There is some evidence these signals are to be driven externally
    into the backplane. This comes from, e.g., PDF344 CRA2 e32.14 `ea
    type 07 h\#400\`.
  * On clk3 we see clock buffers driving backplane pins with `\#20\`
    notation.
	


# Some Things I Changed
* EBUS is a muxed device now instead of a bus with multiple exclusive
  drivers as in the KL10.
  
* Signals of the form `# 00 H` have been renamed to `cram # 00 h` to
  make the compiler simpler.
  
* I had to add leading-zero padding indicators to the signal name
  macros so `ADX CRY [N+6] H` became `adx cry [n+06] h`. This allows
  the explicit definition of how many leading zeroes are required in
  the expansion after the math operation.

* I do not strip newlines embedded in macro selectors, so these have
  to be coded in a single line of text. So

```
	<AK1> [N/30+1,
		ADX CRY [N+6] H,
		CTL ADX CRY 36 H]
```

  is now

```
	{ak1} [n/30+1,adx cry [n+06] h,ctl adx cry 36 h]
```


# Learnings
KL10-PV schematics use symbols that follow a pretty rigorous symbol
naming convention, and the use of this convention is _required_ for
the logic to work.

1. A symbol name always ends in `l` or `h` to indicate its active-low
   or active-high sense.
   
1. A symbol name may be preceded by a `-` to indicate that its sense
   should be reversed for this net. If a schematic uses a symbol like
   `-CTL CONSOLE CONTROL L`, this symbol is actually _identical to_ and
   should be wired to a net with the name `CTL CONSOLE CONTROL H`. The
   `-` effectively changes the sense of the name, allowing a designer
   to pretend a signal is active-low for a net but show that the
   signal is actually generated in its original form as active-high.
   
1. A symbol name may be preceded by something that looks like
   `<BK2>`. This is a reference to a backplane pin on side #2 of the
   `K` signal in the `B` group of pins. Since I have no wirelist or
   schematic for the backplane, I have had to "guess" what the wiring
   is based on symbol names used in module schematics to indicate what
   these pins should be wired to on other modules.
   
1. Each backplane in the system has a backplane type number, a range
   of pin slot groups it spans, and a slot number. For example, the
   EDP in CPU slot #49 is `4AF49` because the CPU backplane type
   number is `4`, it spans the full range of pin groups (`A` through
   `F`) and therefore is a full-height module, and its slot number is
   `49`.

1. Each backplane slot, and also the backplane as a whole, has zero or
   more macro values associated with it. For example, the EDP module
   in slot #49 has `N=12`. The backplane has backplane itself has
   `A=2` and `B=1`. You can see these in my `kl10pv.backplane` source.

1. A symbol name may contain a construct enclosed in `[]` that
   represents a case selector sort of string substitution. The first
   expression, computed in integer arithmetic, is used as a selector
   to determine which of the following items in the comma-delimited
   list of strings should be the selector's expansion. For example,
   for the following, the expansion is `CTL AR 09-17 LOAD L` when `N`
   is 12, and it is `CTL ARR LOAD A L` when `N` is 24.
   
	[N/6+1,
	  CTL AR 00-08 LOAD L,
	  CTL AR 09-17 LOAD L,
	  CTL AR 09-17 LOAD L,
	  CTL ARR LOAD A L,
	  CTL ARR LOAD A L,
	  CTL ARR LOAD A L]

1. Another way to use the `[]` construct is as a simple macro
   expansion. If the `[]`s only contain a single expression with no
   commas, it is this sort of singleton macro. For example `<DL1> AD
   [N=1] H` in slot #49 expands to `<DL1> AD 12 H` for bit #12
   (remember _big-endian bit numbering, so this is in the left half of
   the bus) of the EDP's `AD` register. The evaluated value of the
   expression is always zero-padded to the widest of any value in the
   expression. So if an expression is `[N/6+03]` the value will always
   have two digits even if `N/6` evaluates to `1`. This was really
   hard to figure out until I realized the people who wrote SUDS (the
   system used for schematic capture at Stanford and later at DEC)
   were fucking geniuses. They didn't waste any effort making things
   complicated that could remain really simple and still do a powerful
   job. This is a simple, elegant solution to symbol names that
   contain multiple digits that have to have leading zeroes.
   
1. A wire on a schematic that is labeled something like

	^ARMM 14 H <BH2>
	VMA4 VMA 14 IN H
	
   should be wired to backplane pin `<BH2>` with signal name
   `vma4_vma_14_in_h`.  This is manually connected to `armm_14_h` in
   `kl10pv.sv`. This represents backplane wiring that cannot be
   automatically determined from the name of the netlist (at least not
   with the name `VMA4 VMA 14 IN H`). Examples can be found on VMA4
   PDF357.

1. A wire labeled something like

	ARMM 14 H <BH2>
	
   is the same net as one labeled without the `<BH2>`. This
   accidentally works properly in the compiler since the net names
   don't include the backplane pin in their key. I have tried, by
   convention, to use the fully identified version including the
   backplane pin label everywhere, but I have no tool that enforces
   this at this time.

## Clocking and Delays
From `docs/EK-EBOX-all.pdf`, page `EBOX/3-21` figure 3-20:

	NOTE
		Actually, EBOX CLOCK is
		clocked via CLK ODD which
		occurs ~16ns earlier than
		MBOX CLK.


## SBUS <--> MBOX mappings
* This info is from `io-box*.pdf` DX0 which shows the SBUS[01] signals
  that drive the MBOX `MEM *` signals and vice versa pretty
  clearly. These are not registered except for address latching. They
  are must combinatorial connections with transceivers for TTL<->ECL
  translation in the real KL10PV.
  
		Driving Signal				Driven Signal
	!SBUS[01] ACKN [AB] L		MEM ACKN [AB] H
	!SBUS[01] ERROR L			MEM ERROR H
	!SBUS[01] ADR PAR ERR L		MEM ADR PAR ERR H
	CLK SBUS CLK H				SBUS[01] CLK {INT,EXT} H
	!DATA VALID[AB] OUT H		SBUS[01] DATA VALID [AB] L
	!SBUS[01] DATA VALID [AB] L	MEM DATA VALID [AB] L
	MEM START [AB] H			SBUS[01] START [AB] H
	MEM RQ [0-3] H				SBUS[01] RQ [0-3] H
	MEM RD RQ [0-3] H			SBUS[01] RD RQ [0-3] H
	MEM WR RQ [0-3] H			SBUS[01] WR RQ [0-3] H
	MEM DIAG L					SBUS[01] DIAG L
	-MEM ADR PAR L				-SBUS[01] ADR PAR L
	MB [00-35] H				SBUS[01] D[00-35] H
	SBUS[01] DATA [00-35] H		MEM DATA IN [00-35] H
	PMA [14-35] H				SBUS[01] ADR [14-35] H
	!DIAG MEM RESET H			SBUS[01] MEM RESET L
	MB PAR H					SBUS[01] DATA PAR H
	SBUS[01] DATA PAR H			MEM PAR IN H


# Verilator

## Random Notes
* You can use, e.g., `mod->rootp->kl10pv__DOT__a_change_coming_in_l`
  to refer to a top level signal in C++.
  * See `obj_dir/Vkl10pv___024root.h` for the entire list.


# Front End System Initialization and Management

## KL Master Reset
Note the functions used here are defined in `dte.h` and `dte.svh` in
the `tDiagFunction` enum.
   
1. `diagfCLR_RUN`: Clear RUN flag.
   
1. `diagfCLR_CLK_SRC_RATE`: Set the default clock source.

1. `diagfSTOP_CLOCK`: Stop the KL clock.

1. `diagfRESET_PAR_REGS`: Load clock parity check and "fs check" (what is this?).

1. `diagfCLR_MBOXDIS_PARCHK_ERRSTOP`: Load clock MBOX cycle disables
   for parity check and error stop enable.

1. `diagfCLR_BURST_CTR_RH` and `diagfCLR_BURST_CTR_LH`: Load both
   halves of the burst counter (8,4,2,1) with zero.

1. `diagfSET_EBOX_CLK_DISABLES`: Disable EBOX clock.

1. `diagfSTART_CLOCK`: Start The Clock.

1. `diagfINIT_CHANNELS`: Initialize the I/O channels.

1. `diagfCLR_BURST_CTR_RH`: Load Burst Counter right half (8,4,2,1)
   with zero again.

// Loop up to three times:
//   Do diag function 162 via $DFRD test (A CHANGE COMING A L)=EBUS[32]
//   If not set, $DFXC(.SSCLK=002) to single step the MBOX


$display($time, " [step up to 5 clocks to syncronize MBOX]");
repeat (5) begin
  #500 ;
  if (!mbox0.mbc0.MBC.A_CHANGE_COMING) break;
  #500 ;
  doDiagFunc(diagfSTEP_CLOCK);
end

if (mbox0.mbc0.MBC.A_CHANGE_COMING) begin
  $display($time, " ERROR: STEP of MBOX five times did not clear MBC.A_CHANGE_COMING");
end

// Phase 2 from DMRMRT table operations.
doDiagFunc(diagfCOND_STEP);          // CONDITIONAL SINGLE STEP
doDiagFunc(diagfCLR_RESET);          // CLEAR RESET
doDiagWrite(diagfENABLE_KL, '0);     // ENABLE KL STL DECODING OF CODES & AC'S
doDiagWrite(diagfEBUS_LOAD, '0);     // SET KL10 MEM RESET FLOP
doDiagWrite(diagfWRITE_MBOX, 'o120); // WRITE M-BOX

$display($time, " DONE");


## Front End PDP-11 Code Notes

The primary reference is in `rtl/doc/klinit.l20`.

* `LQSHWE` displays the hardware environment of the KL10.

* `HLTNOE` halts KL and turns off DTE protocol to avoid interference.
  * `..DTSP` turns off protocols (see `rsxt20.l20` for this).
    * Disable DTE interrupts.
	* Clear EF.PR1=0o100000 | EF.PR2=0o020000 in .COMEF+2 to disable protocol.
  * `.CLRUN` in R0 and `$DFXC` halts the KL if it's running.

* `$DFXC` executes the diagnostic function code in R0.
  * This also maintains a status flag in `.CKSW` of -1 for clock
    stopped, +1 for started.
  * As it progresses, `$TRACK` is called to show progress on console.

* `$MCBLD` loads the CRAM and DRAM from their image files.

* `$KLDFX` (in `rsxt20.l20`) manipulates the EBUS to execute a
  diagnostic function.
  
* `RDMCV` reads the microcode version/edit level.
  * Major		{cram[136][29:31],cram[136][33:35]}
  * Subversion	cram[136][37:39]
  * Edit level	{cram[137][29:31],cram[137][33:35],cram[137][37:39]}

* `$RCRAM` reads a specified address in CRAM to 6 word buffer `DCBCBF`.
  * `$DFRD` does diagnostic read

* `$ACRAM` sets the CRAM starting address.

* `$DFXC` starts the KL clock.

## CRAM Loading from KLX.RAM file
* Documentation for the text file format is now in `fe_sim.v` comments.
  * One thing that appears to be wrong is "THE CONTROL RAM CONSISTS OF
    80 BITS PLUS A 5 BIT SPECIAL FIELD PER CONTROL RAM LOCATION." This
    seems inaccurate since PDF347 CRA5 documents _six_ bits of what
    appears to be the special field: `{CALL,DISP[0:4]}` which come
    from `EBUS[00:05]` on diagnostic function 053 (which I call
    `CRAM_WRITE_80_85` for this reason).


# Modeling
* Use SystemVerilog
* Requirements:
  * Set undriven nets to 0.
  * Detect wire-OR and replace with explicit OR in Verilog code.
  * Algorithmically translate symbols from whacky DEC nomenclature to Verilog identifiers.
    * ' ' ==> _
	* '<-' ==> GETS
	* [/,*.-+=#()%^<>&] ==> SYMBOLNAME


# Notes for Backplane _Undriven_ Nets
* `arx 36 h` and `arx 37 h` are not driven anywhere. Should they be?

* What are unlabeled nets `i48.er2` and `i48.es2`?

* `brx 36 h` is supposed to be unconnected?

* TODO: `ccl ch buf en l` probably needs to be connected?

* `ccw buf adr 3 h` does not exist.

* `clk1 clk h` is the clock after it has been output from `clk1 clk
  out h\#20\` and routed all the way around the backplane to
  compensate for line length delay.

* `external clk h` is the external clock input, which is unused?

* The signals `clk3 fs en M h` for `M` in `{a,b,c,d,e,f}` are clock
  sources for debugging, right?

* `clk resp sim h` is unused?
  * This appears in context with `clk4 resp mbox h` as another OR term
    for various ARX selectors.

* `cram # 09 h` through `cram # 35 h` are supposed to be zero because
  `#` is only 9 bits wide.
  
* TODO: `crc buf mb sel h` is not driven and I cannot find who should
  drive it.
  * Is this part of the MASSBUS channel signal set?

* TODO: `crobar e h` should be driven by power on reset circuitry.

* TODO: `pwr warn e h` should be driven by power fail warning circuitry.

* `ebus *` signals are EBUS cabled from frontend.

* `mem *` signals are memory bus signals.

* TODO: `csh7 cca writeback l` and `mtr cca writeback l` need to be
  the same net on the backplane.

* `probe h\#400\` on PDF327 MTR4 is a backplane test point.

* `synchronize clk h` is a backplane test point.

* `force valid match M h` for `M` in `[0-3]` is for testing and
  troubleshooting only?
  
* `ctl spec/gen cry 18 h` on e23.10 PDF364 CTL1 is used in EDP, so I
  added it on `{aa2}` and renamed the local symbol from `ctl1 spec/gen
  cry 18 h`.

* Presumably `deskew clk h` is only used in factory deskew adjustment.

* Presumably all of the `spare` signals are actually unused.


# Hints and Kinks

* For entertainment value and curiousity, I used this command to list
  the unique backplane pin count of each module:

```
  for F in *.bp-pins; do
    M=${F%.bp-pins}
    echo ${M@U}: $( sort -k 1 $F | awk ' {print $1}' | uniq | wc -l )
  done | sort -n -k 2
```



# Glossary

AC                  Accumulator
AC                  Action Count
ACKN                Acknowledge
ACT                 Action
ADA                 Adder A
AD                  Adder
ADB                 Adder B
ADR                 Address
ADX                 Adder Extension
AF                  Action Flag
ALT                 Alternate
ALU                 Arithmetic Logic Unit
APR                 Arithmetic Processor Register
AR                  Arithmetic Register
ARL                 Arithmetic Register Left
ARM                 Arithmetic Register Mixer
ARMM                Arithmetic Register Mixer Mixer
ARR                 Arithmetic Register Right
ARX                 Arithmetic Register Extension
ARXL                Arithmetic Register Extension Left
ARXM                Arithmetic Register Extension Mixer
ARXR                Arithmetic Register Extension Right
BOOLE               Boolean
BR                  Buffer Register
BRK                 Break
BRX                 Buffer Register Extension
BUF                 Buffer
CAM                 Cache Address Mixer
CBUS                Channel Bus
CCA                 Cache Clearer Address
CCL                 Channel Control Logic
CCW                 Channel Command Word
CCWF                Channel Command Word Fetch
C DIR P             Cache Directory Parity
CG                  Carry Generate
CHA                 Channel Address
CHAN                Channel
CH                  Channel
CHK                 Check
CHX                 Cache Extension
CLK                 Clock
CLR                 Clear
COMP                Complete
CON                 Control
COND                Condition
CONS                Constant
CONTR               Control
CP                  Carry Propagate
CP                  Central Processor
CPU                 Central Processing Unit
CRA                 Control RAM Address
CRAM                Control RAM Address Mixer
CRC                 Channel RAM Control
CR                  Control RAM
CRM                 Control RAM
CRY                 Carry
CS                  Controller Select
CSH                 Cache
CTL                 Control
CTOM                Controller-to-Memory or Cache-to-Memory
CTR                 Counter
CWSX                Called With Special Execute
CYC                 Cycle
DAT                 Data
D                   Data
DIAG                Diagnostic
DIF                 Difference
DIR                 Directory
DIS                 Disable
DISP                Dispatch
DIV                 Divide
DRAM                Dispatch RAM
EBR                 Executive Base Register
EBUS                Execution Bus
ECL                 Emitter-Coupled Logic
EDP                 EBox Data Path
E                   EBox Cyc
ENA                 Enable
EN                  Enable
EPT                 Executive Process Table
ERA                 Error Address
ERR                 Error
E to T              ECL to TTL
EX                  Extension
EXP                 Exponent
EXT TRA REC         External Transfer Receiver
FE                  Floating Exponent
FE                  Front End
F                   Function
FLG                 Flag
FM                  Fast memory
FOV                 Floating Overflow
FPD                 First Part Done
FPD                 Floating Point Divide
FUNC                Function
FXU                 Floating Exponent Underflow
GE                  Greater or Equal
GEN                 Generate
G                   Gated
H                   High
INC                 Increment
INH                 Inhibit
IN                  Input
INSTR               Instruction
INT                 Internal
INTR                Interrupt
INVAL               Invalid
IOT                 Input/Output Transfer
IR                  Instruction Register
J                   Jump
LAT                 External
L                   Low
LRU                 Least Recently Used
MBC                 M Box Control
MB                  Memory Buffer
MBX                 M Box Control
MBZ                 M Box Control
MCL                 Memory Control
MEM                 Memory
MHz                 Megahertz
MIX                 Mixer
MQM                 Multiplier Quotient Mixer
MQ                  Multiplier Quotient
MR                  Master
MRU                 Most Recently Used
MTR                 Meter
NICOND              Next Instruction Condition
NXM                 Non-Existent Memory
NXT                 Next
OK                  011 Korrect
OP                  Operation (code)
OVN                 Overrun
PAG                 Pager
PA                  Physical Address
PAR                 Parity
PCF#                Previous Context Flags from Number
PCP                 Previous Context Public
PC                  Program Counter
PERF                Performance
PF                  Page Fault
PGRF                Page Refill
PIA                 Priority Interrupt Assignment
PIH                 Priority Interrupt Hold
PI                  Priority Interrupt
PMA                 Physical Memory Address
PMA                 Physical Memory Address Selector
PREV                Previous
PT                  Page Table / Process Table
PTR                 Pointer
PWR                 Power
RAM                 Random Access Memory
RD                  Read
REC                 Receive
REF                 Reference
REG                 Register
REL                 Release
REQ                 Request
RE                  Receive ECL
RESP                Response
RES                 Reset
RET                 Return
RIP                 Request In Progress
RQ                  Request
S ADR P             Storage Address Parity
SBR                 Subroutine
SBUS                Storage Bus
SCADA               Shift Count Adder A
SCADB               Shift Count Adder B
SCAD                Shift Count Adder
SCD                 Shift Count Adder
SCM                 Shift Count Mixer
SC                  Shift Count
SEL                 Select
SHRT                Shift Right
SH                  Shifter
SIM                 Simulate
SPEC                Special
SP                  Special
SR                  State Register
ST                  Start
SYNC                Synchronize
TE                  Transmit ECL
TRA                 Transfer
T                   Time
TTL                 Transistor-Transistor Logic
T to E              TTL to ECL
UBR                 User Base Register
UCODE               Microcode
VAL                 Valid
VMA                 Virtual Memory Address
WARN                Warning
WC                  Word Count
WD                  Word
WR                  Write
XFER                Transfer
XR                  Index Register
