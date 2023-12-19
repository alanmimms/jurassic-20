This list is meant to show major status milestones and to list the
challenge-_du-jour_ and keeping history of it to show progress over
time.

# TO DO

* Redo these boards from new layout version of schematics (missed that
  in first pass). If I don't do this they will not be easy to debug
  and won't be maintainable and probably won't work properly with all
  features. Reworked boards are usually minimum to get it to work and
  not complete with all fixes from the new version in my
  experience. We'll see...
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

### `CONO PAG,0` Hangs

[2024.12.14] I can run microcode to the point that the `execKLInstr()`
for `CONO PAG,0` instruction hangs. This is apparently caused by the
microcode accessing the EPT register in the MBOX and getting no
response from MBOX, so it hangs forever with `apr6 ebox ebr h` and
`con mbox wait l` asserted. I need to debug why MBOX register accesses
never finish.

[2024.12.19] When the `CONO PAG,0` instruction is issued by the FE, it
eventually hangs because the `CORE BUSY L` signal is assserted.  This
was asserted by the `MEM/MB WAIT` in the `NXT INSTR` macro at `FINI:`
(U 0133) in the microcode. This seems to be a "discovered wait"
condition (like a "discovered check" in chess), and it causes the next
MBOX interaction (which is the attempt to set the EBR register value)
to hang forever waiting for `CORE BUSY L` to deassert.


## History of _What I'm Doing Now_
