# Thoughts:

* It's better to transform AST into netlist structure at top level
    production of each parse (sub)tree.

* This decouples netlist structure from AST structure near where AST
    structure is defined.

* This decouples uses of netlist structure from AST structure.

# Data

## Data Needed

* Board level wiring: Interconnect nets with same local net name
  (`lNet`) on each chip on reach board. On the board `lNet` is the net
  name.

* CRAM bit naming per slot: Interconnect nets with same global net
  name (`gNet`) by backplane pins for CRM board slots. On the
  backplane, `gNet` is the net name.

* Backplane level wiring: Interconnect nets with same global net name
  (`gNet`) by backplane pin. On the backplane, `gNet` is the net name.
  This `gNet` is initialized from the board's `lNet` and then
  overridden by the CRAM global net name if there is one for this
  slot.


# RTL Generation

* Don't evaluate macros for board local symbols.
  * Keep those symbols generic for each instantiation of the board.
* Generate each board's RTL from local symbols with interface for
  backplane pins.
  * Each backplane pin uses its _local symbol name_ for the board's
    SV module interface.
* Assign CRAM global names to slot specific backplane pins.
* Evaluate macros for global symbols on backplane pins.
* Generate backplane's RTL using global symbols.
  * Instantiate each module in each slot it appears in, wiring its
    interface to the slot's global symbol for each backplane pin it
    uses.


## Data Available


# Modeling
* Use SystemVerilog
* Requirements:
  * Set undriven nets to 0.
  * Detect wire-OR and replace with explicit OR in Verilog code.
  * Algorithmically translate symbols from whacky DEC nomenclature to Verilog identifiers.
    * ' ' ==> _
	* '<-' ==> GETS
	* [/,*.-+=#()%^<>&] ==> SYMBOLNAME


# TODO:

* E.g., these two signals should be attached to three slots each:

     cram arxm sel 4 00 h:
       DP02.e60.4     edp.ff1[52]    PDF16

     cram arxm sel 4 06 h:
       DP02.e60.4     edp.ff1[52]    PDF16

* Signals that don't go to a backplane pin _must_ stay local to the
  module even if they have names that match global signal names. E.g.,
  `ad cry -02 h` is local to EDP and also global driven by `IRD.ca1` to
  `CRA.cf1`.

* Make board definitions instantiate a complete new data structure for
  each slot the board is in so we can add/change/specialize the data
  there for each slot (especially for signals for CRAM bits on
  backplane).

* Binding between net and module.pin[backplane.slot] needs to be done
  specific to slot. For example `hi 04` should be bound to
  `crm.de1[ebox.50]`.

* Finish defining signals for CRAM bits on backplane.


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
