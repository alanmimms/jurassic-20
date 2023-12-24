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
wire-OR. Inputs left unconnected see a real logic zero. You can
relying on gates whose outputs are looped back to their inputs to
implement latches. This latter practice in today's logic and methods
leads to circular logic dependencies, metastability black-holes, and
madness.


## What I'm Doing Now - Occasional Status and Progress Notes

### Two Nested Microinstruction Calls Hangs on Outer Return

[2023.12.22] The microcode hangs in a two microinstruction loop
0475/3143. The sequence is

	2752:			... CALL CLRPT
	3605: CLRPT:	...
	3142:			... CALL ARSWAP
	0475: ARSWAP:	... RETURN1			; Loop start (DOES return to 3143)
	3143:			... RETURN4			; Loop end (SHOULD return to 2756)
	
I'd bet this is the first time the microinstruction call stack has
ever been pushed two deep. Hmmm...


## Bugs Outstanding TODO

* At `CRA-LOC` 0143 comment says AR should have 77,,777776, but my AR
  has 77,,777777. Probably this is something wrong with ALU backplane
  wiring and related to carry in.


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
copy I have.

