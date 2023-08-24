# Top level Makefile for the KL10 with Verilator.

TOPEXE = $(RTLOBJDIR)/kl10pvtb

MODULES = \
    apr cac ccl ccw cds ch0a ch0 ch0x cha chc chx ci clk cnt con cra crc \
    crm csh ctl dlh dmc dps dt0 dtr dx0 edp ignore int ird ma0 mb0 mbc mbx \
    mbz mcl mtr pag pic pma scd shm vma

BOARDS = $(foreach M,$(MODULES),board/$(M).board)

RTLDIR = ./rtl
GENRTLDIR = $(RTLDIR)/gen
RTLOBJDIR = ./rtl/obj_dir


.PHONY: all clean

all:	.sim.build $(TOPEXE)

$(TOPEXE):
	make -C $(RTLDIR)

.sim.build:	kl10pv.backplane netlist.pegjs sim sim.js logic.js compile.js $(BOARDS)
	./sim -g
	touch .sim.build

clean:
	@rm -f .sim.build
	@yarnpkg run clean
	@rm -f kl10 $(GENRTLDIR)/*
	@make -C $(RTLDIR) clean
