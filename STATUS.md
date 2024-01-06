This list is meant to show major status milestones and to list the
challenge-_du-jour_ and keeping history of it to show progress over
time.

# TO DO

* Redo these boards from new layout version of schematics (missed that
  in first pass). If I don't do this they will not be easy to debug
  and won't be maintainable and probably won't work properly with all
  features. Reworked boards are usually minimum to get it to work and
  not complete with all fixes from the new version based on my belief
  system. We'll see...
  1. CCL
  1. CRC
  
* Determine use of `CLK EBUS CLK H` <BK1> on CLK1 E66. This is clock
  to I/O backplane? FYI, the `CLK 10/11 CLK H` on CLK2 E60 is already
  used by fe_sim.sv (DTE20 front end).


# Status
Basic schematic netlist conversion into my board language is
complete. Now to debug and find all of the typos.
  
KL10-PV CPU used a _lot_ of what are today considered bad practices in
hardware. I need to find these and eradicate them and replace them to
more modern ways. For example, the clock signals are passed through
delay lines in various places to provide timing for multi-phase
operations. This must be converted to a multi-phase clock discipline
that does the same thing but subdividing the traditional clock pulses.

The KL10-PV has many presumptions based on its ECL implementation.
For example, in ECL you can just parallel connect outputs to get a
wire-OR. Inputs left unconnected see a real logic zero.


## What I'm Doing Now - Occasional Status and Progress Notes

* Memory is now blocking my progress. I have loaded the `klddt`
  "bootloader" into `memory0` via testbench subterfuge. Now I need the
  EBOX to be able to request from MBOX the words it needs, by
  performing read cycles on the MB20 via SBUS.

  * It appears MBOX cannot accept SBUS.ackn on each clock. There has
    to be enough time between the bits to allow MBOX to shift out
    leading zeros in RQ and to skip zeros in RQ before another ackn
    can be seen.  I believe this restriction also applies to the
    `validIn` and `validOut` signals to clock data through the
    interface. These cannot be asserted during a clock when the MBOX
    is skipping a zero bit in RQ.
  * My current implementation doesn't handle discontiguous bits in
    SBUS.RQ. In `EK-MBOX-UD-004_May77-ocr.pdf` on PDF201 MBox/3-77
    there is a table that clearly shows RQ being set up with
    discontiguous bits.
  * In `EK-MBOX-UD-004_May77-ocr.pdf` on PDF200 MBox/3-76 is this:

	_The MBox core control waits two MBox clock ticks after receiving
    `SBUS DATA VALID` for the data bus drivers to stabilize before
    loading the data into the appropriate MB._

    Also, `EK-MBOX-UD-004_May77-ocr.pdf` PDF204 MBox/3-80 says this:
  
	  _After the SBUS DATA VALID pulse is received, the MBox core
      control waits two clock ticks before it triggers the MB control
      to transfer the data from the SBus data lines into the
      appropriate MB_

    These statements imply the `SBUS.validIn` signal and the data
    lines must remain stable for two (three?) clocks after
    `SBUS.validIn` is initially asserted.


## Bugs Outstanding TODO

* At `CRA-LOC` 0143 comment says AR should have 77,,777776, but my AR
  has 77,,777777. Probably this is something wrong with ALU backplane
  wiring and related to carry in.

* Last I checked, I was getting CRAM parity errors.

* Last I checked, I was getting FM parity errors. I think I solved the
  FM parity errors by setting up parity in my `fe_sim.sv` function
  `loadAC()`, but I have not checked since to see if this is the case.


## History of _What I'm Doing Now_

### `CONO PAG,0` Hangs

[2023.12.14] I can run microcode to the point that the `execKLInstr()`
for `CONO PAG,0` instruction hangs. This is apparently caused by the
microcode accessing the EPT register in the MBOX and getting no
response from MBOX, so it hangs forever with `apr6 ebox ebr h` and
`con mbox wait l` asserted. I need to debug why MBOX register accesses
never finish.

[2023.12.19] When the `CONO PAG,0` instruction is issued by the FE, it
eventually hangs because the `CORE BUSY L` signal is assserted.  This
was asserted by the `MEM/MB WAIT` in the `NXT INSTR` macro at `FINI:`
(U 0133) in the microcode. This seems to be a "discovered wait"
condition (like a "discovered check" in chess), and it causes the next
MBOX interaction (which is the attempt to set the EBR register value)
to hang forever waiting for `CORE BUSY L` to deassert.

[2023.12.22] But now there is a hang. The hang is a two
microinstruction infinite loop between 0475 and 3143 entered from the
instruction at `CLRPT`=3605. 3172 has `MB WAIT` in it, and the `MEM
BUSY H` signal has been asserted since the `NXT INSTR` at `FINI` after
the microcode is started up the first time with CONTINUE button but
halted with AR set to `CONO APR,267760` instruction by the
`startKLBoot()` sequence.

[2023.12.22] This was caused by `CLK4 EBOX REQ L` glitch, which
resulted from misreading the print on CLK4 because of a smudge in the
copy I have. I guess I'll never get back those eight days I spent
hunting for this.


### EBUS Diagnostic Write and Diagnostic Function are flakey

I have struggled to figure out how EBUS should be timed between the FE
(DTE) and the EBOX. I kept adding more clock delays between
EBUS.diagStrobe assertion and deassertion to see if that fixed it, and
was under the impression it did. But now my LOAD AR operations are
only working about 1/2 the time, and I decided to go figure that
out. It's crucial these work properly to set up the KL to run its
booted image (which, at present, is klddt).

I found E12 in the CLK module is leaving its Q1 output (pin 15) high
during the STOP CLOCK hiatus of CLK1 ODD A H while the diagnostic
operation is happening, but the input D1 on the last CLK1 ODD A H
posedge is low. WTF? This is what led me to consider the possibility
that the `clk` input to the MC10141 at E12 was confused with the
higher speed global signal that was known as `clk` until I changed it
just now to `clk master`. This had no effect, which is what I
expected. I can see the inputs to E12 properly showing CLK1 ODD A H
pausing while low, but nevertheless the Q1 output goes high half a
tick after this pause begins even though the D1 input stays low!
Seriously: WTaF?

Later, I changed the `verilator-main.cc` main loop to go forward in
time by one unit of time per iteration and to just invert `top->clk60`
each iteration instead of using the former slightly unrolled loop
strategy of combining both edges in a single iteration. This changed
things! Now I see the D1 input to E12 goes high, but _only while the
E12 clk input is low_ so this shouldn't change the Q1 output at all,
but it does!

In fact, it appears the E18.nqb (pin 14) output is going high for the
something analogous to the same reason I was having problems with E12!
`CLK3 SYNC L` goes low when there is no E10 `CLK2 MBOX CLK E H` clock
posedge to change it, and this is an MC10176 hex DFF with the same
problem. Can it be my understanding of basic SystemVerilog and
clocking of registers is flawed?

SOLVED: This apparently was a bug in Verilator 5.012 which is what I
had been using. I upgraded to 5.020 just now and the problem magically
went away! I have always been using the `stable` branch of
Verilator. Apparently this version is more stable than the previous
stable version.

BUT WAIT THERE'S MORE: The "solution" above wasn't a solution. The
symptom was that I would see in `mc10141.sv` both a posedge on `clk`
and a negedge on `clk` at the same time tick! I saw this by adding
some `$fdisplay()` junk to show time and both clock edges (even though
the model was supposed to only change on posedge). The problem was
caused by a glitch in the `mc10141.sv` clock from a race induced in
CLK1 by zero delay being substituted for the 5.0ns delay line between
CLK1 MAIN SOURCE C H and E51 pin4. Replacing this zero delay with a
delay based on a single edge of `clk60` solved it.


### Two Nested Microinstruction Calls Hangs on Outer Return

[2023.12.22] The microcode hangs in a two microinstruction loop
0475/3143. The sequence is

	2750: SETEBR:   ... CALL SHIFT
	2604: SHIFT:      ... RETURN2
	2752:			... CALL CLRPT
	3605: CLRPT:	...
	3142:			... CALL ARSWAP
	0475: ARSWAP:	... RETURN1			; Loop start (DOES return to 3143)
	3143:			... RETURN4			; Loop end (SHOULD return to 2756)
		-- BEGINNING OF WRONGITUDE --
    0004: ...
	
I'd bet this is the first time the microinstruction call stack has
ever been pushed two deep. Hmmm... It looks like `RETURN4` is getting
zero as its input to OR `4` into.

The sequence should be

	2750: SETEBR:   ... CALL SHIFT
	2604: SHIFT:      ... RETURN2
	2752:			... CALL CLRPT
	3605: CLRPT:	  ...
	3142:			  ... CALL ARSWAP
	0475: ARSWAP:	    ... RETURN1			; Loop start (DOES return to 3143)
	3143:			  ... RETURN4			; Loop end (SHOULD return to 2756)
	2756: KEEPME:   ... J/PTLOOP
	2546: PTLOOP:   ...

#### Simplified CRA Stack Pointer Scheme

CRA4 CALL, RESET, 1777 H means push the CRA-LOC. In my simplified
stack pointer scheme, this is done on CRA3 CLK A H posedge loading
CRA-LOC into `sbrRet` and incrementing `craSP`.

CRA4 RET AND -1777 H means pop the stack while CRA4 SBR RET 00..10 H
is driven with the popped CRA-LOC value. This done by clocking the top
of stack into `sbrRet` and decrementing `craSP` on CRA4 CLK A H
posedge.

Testing.
	0142: ... CALL[ROTS]		; ROTS=0044
	0044: ... RETURN3			; SHOULD return to 0143
	
RESOLUTION: My new simplified stack pointer code is working.
