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


# History
The predecessor to this project, which is still around for reference,
is a modern KL10-PV implementation I did by coding SystemVerilog
directly while keeping one eye on the schematics and trying to build
the logical equivalent in modern SV syntax.

The biggest issue with this effort -- one that leaves it peppered with
a huge number of randomly dispersed logical errors -- is the fact that
I didn't understand the KL10-PV symbol naming scheme when I was
writing the SystemVerilog. Because of this, I know I have hundreds or
thousands of errors in logic that have the sense of signals backwards
or use negative logic when positive logic was actually what was
required. See the `Learnings` section below for details.
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
