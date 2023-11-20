# Top level Makefile for the KL10 with Verilator.

TOPEXE = $(RTLOBJDIR)/kl10pvtb

MODULES = \
    apr cac ccl ccw cds c0a ch0 c0x cha chc chx ci clk cnt con cra crc \
    crm csh ctl dlh dmc dps dt0 dtr dx0 edp ignore int ird ma0 mb0 mbc mbx \
    mbz mcl mtr pag pic pma scd shm vma

BOARDS = $(foreach M,$(MODULES),board/$(M).board)

RTLDIR = ./rtl
GENRTLDIR = $(RTLDIR)/gen
RTLOBJDIR = ./rtl/obj_dir


.PHONY: all clean

all:	.compile.build $(TOPEXE) tools/tff-w36-commacomma

$(TOPEXE):
	make -C $(RTLDIR)

cram-backplane.csv: cram-backplane.ods
	libreoffice --convert-to csv $<

.compile.build:	kl10pv.backplane netlist.pegjs \
		compile compile.js logic.js \
		cram-backplane.csv $(BOARDS)
	./compile -g
	touch $@

tools/tff-w36-commacomma:	tools/tff-w36-commacomma.c

clean:
	@rm -f .compile.build
	@yarnpkg run clean
	@rm -f kl10 $(GENRTLDIR)/*
	@make -C $(RTLDIR) clean
