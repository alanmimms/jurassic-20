Get it? *Jurassic-20* is a portmanteau on an era long ago from which
one might resurrect dinosaurs and the dinosaur I'm resurrecting is the
DECSYSTEM-20. In its original hardware implementation, from the
schematics, as logic that can be simulated and eventually synthesized
into an FPGA implementation that is cycle accurate and runs the very
same microcode and all software (given enough I/O peripheral
emulations).

This is totally a playground, and it's also a work in progress.

The process has been to take the DECSYSTEM-20 KL10PV CPU schematics
and create a logical description of the entire system's netlists so I
can emit SystemVerilog. This would then allow me to run the
DECSYSTEM-20 microcode and thus the entire system, given peripherals
and a front-end to pull the strings to get it loaded and started and
to provide a console and etc.

I know it's a huge project. It's a hobby. I don't really have a reason
for doing it other than that I like the idea, and there's _something_
about the PDP-10 instruction set and architecture that attracts
me. As a hobby I expect it to entertain me for years.

We'll see.


# Architecture
The backplane and netlist are written in a language I designed for
this purpose. This is parsed by a JavaScript based "compiler" that
uses a PEG grammer based on [PEGjs.org](https://pegjs.org/). This
sucks up the dozens of board language modules, one for each module
type, and a backplane description, error checks it a bit, and
generates SystemVerilog to build the netlists and wire the modules
together using the symbolic naming conventions the original KL10-PV
designers used.

The modules are basically lists of chips and their reference
designators and the names of the signals the pins should be connected
to. I try to keep the PDF page number (of the Holy
`docs/MP00301_KL10PV_Jun80-OCR.pdf`) in each schematic page with its
chips so I can easily find things. The OCR in the PDF is nearly
useless, so I cannot easily search there for signals or reference
designators, so I have to do it all as a sort of "Where's Waldo"
exercise. I'm getting pretty good at this after doing it for so long,
but it's certainly tedious.

I tried again with OCR using a more modern version of Tesseract OCR
(`tesseract 4.1.1`). The result is called
`docs/MP00301_KL10PV_Jun80-OCR2.pdf` and it's also where I have added
scribbled highlighter marks to show my pin-by-pin review progress,
which is taking many, many days to complete. This process, while
tedious and exhausting, has found many problems that would have
required many _more_ hours to debug in the functioning KL10
simulation, so it's definitely worth it. In the end, I will
_definitely_ require a new eyeglasses prescription.

I had to add some escape hatches to allow Verilog code to be
subsituted for the traditional symbol names in some cases so I could
replace direct drive of the EBUS data line signals with my per-module
interface that is used as input to the EBUS mux I had to build, for
example. This allows use of verilog symbol names and expressions for a
pin's net name, and there's a variation that can be used as a similar
escape to allow module header input/output port definitions to be in
Verilog, and a third to allow arbitrary Verilog to be inserted into
the generated output in the code for a module.

Of course, I have written the top level in System Verilog, and I have
written the "test bench" that runs the thing under Verilator in C++.


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

I can generate SystemVerilog from the entire netlist of all boards in
all slots. I can run Verilator on the result and am now starting to
weed through the `Circular combinational logic` errors I get.

The first of these, which is on its way to being solved now, was the
EBUS data lines, which also suffered from the wire-OR presumption and
had to be methodically muxed instead. I put this mux in the top level
and each board that has to drive EBUS data lines now provides an
`EBUSdriver` signal and set of data lines that are used as inputs to
that mux.

I haven't gotten through the circular combinational logic morass
yet. When I do, I expect to spend a bunch of time converting the
clocking scheme to use a multi-phase clock, as described above. Since
I don't have an actual KL10-PV to look at, I have no clear vision of
what the clock output of the CLK module looks like, although there are
many hints and one or two good timing diagrams that show some of it.


# History
The predecessor to this project, which is still around for reference,
is a modern KL10-PV implementation I did by coding SystemVerilog
directly while keeping one eye on the schematics and trying to build
the logical equivalent in modern SV syntax.

The biggest issue with this effort, one that leaves it peppered with a
huge number of randomly dispersed logical errors, is the fact that I
didn't understand the KL10-PV symbol naming scheme when I was writing
the SystemVerilog. Because of this, I know I have hundreds or
thousands of errors in logic that have the sense of signals backwards
or use negative logic when positive logic was actually what was
required. See the `Learnings` section below for details.


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


# How to Build
It's pretty easy on Ubuntu 22.04, which is what I have been using. I
couldn't easily tell you which packages you need, but there aren't
many you'll have to add.

* Clone the project's git respository and go into the top level
  directory.
* Clone https://github.com/verilator/verilator and install its
  required packages and build it. I used the `stable` tag version
  which I _think_ is `v5.012`.
* Install Yarn package manager `sudo apt install yarnpkg` (the NodeJS
  package manager). You could use npm also, I think, if you want to.
* Install `gtkwave` to look at the resulting waveform data.
* Run the `yarnpkg` command to install the required JavaScript packages
  for the compiler.
* Run `make` and fix any missing tools or dependencies. For now, you
  may have to do this because I don't want to pollute my Makefiles
  with extra subdir garbage yet:

	make && make -C rtl && ./kl10pv


# Tools
## 36 bit → LH,,RH Translate-Filter-Process for GTKWave
I got tired of seeing unnaturally huge octal numbers, so I wrote a
"translate filter process" for GTKWave to translate hexadecimal 36-bit
numbers into canonical LH,,RH form as always seen in the PDP-10
universe. This is in `tools/tff-w36-commacomma`. It is meant to be
called from GTKWave as a "translate filter process", which takes a
(hexadecimal) number per line as input on its stdin and returns the
octal LH,,RH form on a single line on stdout. The program loops
forever until EOF on stdin.

