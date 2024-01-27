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

The machine is clocked using a four phase top level clock so I can
model and synthesize the random delay lines used in the original KL10.
These are the phases and their applications, listed in order of phase:


## Phase `ph1`

My fake signal `CLK MASTER`. This is a standin for the 60MHz on-board
oscillator on CLK1.


## Phase `ph2`

Provides the ~10ns delayed `CLK1 EBUS SOURCE H` on CLK1.


## Phase `ph3`

Provides the ~45ns delayed `CLK1 SOURCE DELAYED H` on CLK1.


## Phase `ph4`




# History
The predecessor to this project, which is still around for reference,
is a modern KL10-PV implementation I did by coding SystemVerilog
directly while keeping one eye on the schematics and trying to build
the logical equivalent in modern SV syntax.

The biggest issue with that effort -- one that leaves it peppered with
quite some number of randomly dispersed logical errors -- is the fact
that I didn't understand the KL10-PV symbol naming scheme when I was
writing the SystemVerilog. Because of this, I know I have many errors
in logic that have the sense of signals backwards or use negative
logic when positive logic was actually what was required. See the
`Learnings` section below for details.


# How to Build
It's pretty easy on Ubuntu 22.04, which is what I have been using. I
couldn't easily tell you which packages you need, but there aren't
many you'll have to add.

* Clone the project's git respository and go into the top level
  directory.
* Clone https://github.com/verilator/verilator and install its
  required packages and build it. I used the `stable` tag version, and
  I found that `stable` version 5.012 was buggy for clocking my
  mc10141 and mc10176 models, but Verilator `stable` 5.020 is working
  well.
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
