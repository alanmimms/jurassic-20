# Use CACHELESS or CACHE
KLTYPE = CACHELESS

MODS = \
    mc10101 mc10103 mc10104 mc10105 mc10107 mc10109 \
    mc10110 mc10113 mc10117 mc10118 mc10121 mc10131 \
    mc10136 mc10141 mc10144 mc10145 mc10147 mc10415a \
    mc10158 mc10160 mc10161 mc10162 mc10164 mc10165 \
    mc10173 mc10174 mc10176 mc10179 mc10181 mc10210 \
    oscillator seq delay1 delay2 delay3 delayN delayNinverted \
    just_a_wire delay_line tapped_delay_20_2 tapped_delay_50_10 \
    just_six_zero wire6

LOGIC_TESTS = mc10136 mc10141 mc10181

TOP = kl10pv

VERILATORROOT = $(HOME)/verilator
VOBJDIR = ./obj_dir
LOGICDIR = logic
GENDIR = ./gen

SLOTNAMES-CACHE = \
    apr34 cac17 cac19 cac24 cac25 ccl11 ccw12 cha27 chc09 chx28 clk32 \
    con35 cra45 crc10 crm40 crm42 crm44 crm50 crm52 csh23 ctl36 edp39 \
    edp41 edp43 edp49 edp51 edp53 ird48 mb014 mb015 mb016 mbc22 mbx21 \
    mbz20 mcl47 mtr33 pag30 pic31 pma29 scd54 shm46 vma38

SLOTNAMES-CACHELESS = \
    apr34 ch017 ch019 ch024 ch025 ccl11 ccw12 c0a27 chc09 c0x28 clk32 \
    con35 cra45 crc10 crm40 crm42 crm44 crm50 crm52 csh23 ctl36 edp39 \
    edp41 edp43 edp49 edp51 edp53 ird48 mb014 mb015 mb016 mbc22 mbx21 \
    mbz20 mcl47 mtr33 pag30 pic31 pma29 scd54 shm46 vma38

SLOTNAMES = $(SLOTNAMES-$(KLTYPE))

SVFILES = \
	kl10pv.sv \
	fe_sim.sv \
	mb20.sv \
	$(foreach M,$(MODS),$(LOGICDIR)/$(M).sv) \
	$(foreach M,$(SLOTNAMES),$(GENDIR)/$(M).sv) \

SVHFILES = $(TOP).svh $(DTEINTF) logic.svh
CXXFILES = verilator-main.cc
CFILES = fe.c
HFILES =
TBDIR = tb
TBOBJS = $(foreach F,$(CFILES:.c=.o) $(CXXFILES:.cc=.o),$(VOBJDIR)/$F)
DTEINTF = dte.h dte.svh
DTETFF = dte.tff

EXE = $(VOBJDIR)/kl10pvtb
LOGICEXEs = $(foreach M,$(MODS),$(VOBJDIR)/V$(M)-tb)

#DEBUG = -g
DEBUG =
OPTIMIZE = -O2
VERILATOR ?= verilator

KILLWARNINGS = \
	-Wno-LITENDIAN \
	-Wno-UNOPTFLAT \
	-Wno-INITIALDLY \
	-Wno-SELRANGE \
#	-Wno-DECLFILENAME \
#	-Wno-CLKDATA \
#	-Wno-TIMESCALEMOD

DEBUG_DIDNOTCONVERGE = --prof-cfuncs -CFLAGS -DVL_DEBUG

DEFINES = -D$(KLTYPE)
INCDIR = $(VERILATORROOT)/include
CFLAGS += -I$(VOBJDIR) -I$(INCDIR) -I$(INCDIR)/vltstd -std=gnu++14 $(DEBUG) $(OPTIMIZE) $(DEFINES)
CXXFLAGS += -I$(VOBJDIR) -I$(INCDIR) -I$(INCDIR)/vltstd $(DEBUG) $(OPTIMIZE) $(DEFINES)
CPPFLAGS += -DVL_DEBUG $(DEFINES)

VFLAGS = \
	--stats \
	--default-language 1800-2017 +1800-2017ext+sv \
	-CFLAGS \
	-MMD \
	-I. \
	-I$(GENDIR) \
	$(DEFINES) \
	$(KILLWARNINGS) \
	-Wwarn-UNDRIVEN \
	--CFLAGS "$(DEBUG) $(OPTIMIZE)" \
	--compiler gcc \
	--timescale 10ns --timescale-override 10ns \
	--timing \
	--trace --trace-structs \
	--clk clk60 \
	--x-initial 0 \
	-cc --build --exe -j 9

.PHONY:	all logic-tb clean tests

all:	$(EXE)

logic-tb: $(MODS)

### Default rules...
-include $(VOBJDIR)/*.d

# Include global rules
include $(VERILATORROOT)/include/verilated.mk

$(EXE):	$(SVFILES) $(CXXFILES) $(CFILES) $(HFILES) $(SVHFILES) $(DTEINTF)
	$(VERILATOR) $(VFLAGS) $(filter-out %.h, $^) --top-module $(TOP) -o $(@F)

$(DTEINTF) $(DTETFF): dte-interface.js
	node dte-interface.js -- $(DTEINTF) $(DTETFF)

$(MODS): $(foreach M,$(MODS),$(VOBJDIR)/V$(M))

# Holy fucknoodles these two steps were complicated to get "right".
$(foreach M,$(MODS),$(VOBJDIR)/V$(M).mk): $(VOBJDIR)/V%.mk: $(LOGICDIR)/%.sv
	$(VERILATOR) -Wall --trace --cc $< --exe $(TBDIR)/$*-tb.cc

$(foreach M,$(MODS),$(VOBJDIR)/V$(M)-tb): $(VOBJDIR)/V%-tb: $(TBDIR)/%-tb.cc $(VOBJDIR)/V%.mk
	$(MAKE) -C $(VOBJDIR) -f V$*.mk

clean:
	@rm -fr obj_dir
	rm -rf $(VOBJDIR) $(DTEINTF) $(DTETFF) $(foreach F,$(EXE),tb/$(EXE))

# TODO Add back mc10181 test
tests:	$(foreach T,$(LOGIC_TESTS),$(VOBJDIR)/test-$(T))

$(VOBJDIR)/test-%:	rtl/tb/%_tb.sv rtl/logic/%.sv rtl/logic.svh rtl/util.svh
	$(VERILATOR) \
		$(VFLAGS) -DTESTBENCH \
		$^ \
		--top-module $(basename $(notdir $<)) \
		--main --timing \
		-o $(@F)
