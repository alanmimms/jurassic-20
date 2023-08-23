MODS = \
    mc10101 mc10103 mc10104 mc10105 mc10107 mc10109 \
    mc10110 mc10113 mc10117 mc10118 mc10121 mc10131 \
    mc10136 mc10141 mc10144 mc10145 mc10147 mc10415a \
    mc10158

TOP = kl10pv

VERILATORROOT = $(HOME)/verilator
VOBJDIR = ./obj_dir
LOGICDIR = logic

SVHFILES = $(TOP).sv $(DTEINTF)
CXXFILES = verilator-main.cc
CFILES = fe.c
HFILES =
TBDIR = tb
TBOBJS = $(foreach F,$(CFILES:.c=.o) $(CXXFILES:.cc=.o),$(VOBJDIR)/$F)
DTEINTF = dte.h dte.svh

EXE = $(VOBJDIR)/kl10pvtb
LOGICEXEs = $(foreach M,$(MODS),$(VOBJDIR)/V$(M)-tb)

DEBUG = -g
OPTIMIZE =
VERILATOR ?= verilator

KILLWARNINGS = \
	-Wno-LITENDIAN \
	-Wno-UNOPTFLAT \
	-Wno-DECLFILENAME \
	-Wno-CLKDATA \
	-Wno-TIMESCALEMOD

INCDIR = $(VERILATORROOT)/include
CFLAGS += -I$(VOBJDIR) -I$(INCDIR) -I$(INCDIR)/vltstd -std=gnu++14 $(DEBUG)
CXXFLAGS += -I$(VOBJDIR) -I$(INCDIR) -I$(INCDIR)/vltstd $(DEBUG)
CPPFLAGS += -DVL_DEBUG

VFLAGS = \
	--stats \
	--trace --trace-structs \
	--default-language 1800-2017 +1800-2017ext+sv \
	-CFLAGS \
	-MMD \
	-I../grtl \
	$(KILLWARNINGS) \
	--timescale 1ns/1ps --timescale-override 1ns/1ps \
	--x-initial 0 \
	-cc --build --exe -j 9

.PHONY:	all logic-tb clean

all:	$(EXE) $(LOGICEXEs)

logic-tb: $(MODS)

### Default rules...
-include $(VOBJDIR)/*.d

# Include global rules
include $(VERILATORROOT)/include/verilated.mk

$(EXE):	$(SVFILES) $(CXXFILES) $(CFILES) $(HFILES) $(SVHFILES)
	$(VERILATOR) $(VFLAGS) $(filter-out %.h, $^) --top-module $(TOP) -o $(@F)

$(DTEINTF): dte-interface.js
	node dte-interface.js -- $(DTEINTF)

$(MODS):	$(foreach M,$(MODS),$(VOBJDIR)/V$(M))

# Holy fucknoodles! These two steps were complicated to get "right".
$(foreach M,$(MODS),$(VOBJDIR)/V$(M).mk): $(VOBJDIR)/V%.mk: $(LOGICDIR)/%.sv
	$(VERILATOR) -Wall --trace --cc $< --exe $(TBDIR)/$*-tb.cc

$(foreach M,$(MODS),$(VOBJDIR)/V$(M)-tb): $(VOBJDIR)/V%-tb: $(TBDIR)/%-tb.cc $(VOBJDIR)/V%.mk
	$(MAKE) -C $(VOBJDIR) -f V$*.mk

clean:
	@rm -fr obj_dir
	rm -rf $(VOBJDIR) $(DTEINTF) $(foreach F,$(EXE),tb/$(EXE))
