# Top level Makefile for the KL10 with Verilator.

TOPEXE = $(RTLOBJDIR)/kl10pvtb

MODULES = \
    apr cac ccl ccw cds ch0a ch0 ch0x cha chc chx ci clk cnt con cra crc \
    crm csh ctl dlh dmc dps dt0 dtr dx0 edp ignore int ird ma0 mb0 mbc mbx \
    mbz mcl mtr pag pic pma scd shm vma

BOARDS = $(foreach M,$(MODULES),board/$(M).board)

IMAGES = $(foreach F,CRAM.mem DRAM.mem,images/$F)

RTLDIR = ./rtl
GENRTLDIR = $(RTLDIR)/gen
RTLOBJDIR = ./rtl/obj_dir


.PHONY: all clean

all:	.compile.build $(TOPEXE)

$(TOPEXE):
	make -C $(RTLDIR)

cram-backplane.csv: cram-backplane.ods
	libreoffice --convert-to csv $<

$(IMAGES) .compile.build:	kl10pv.backplane netlist.pegjs \
				compile compile.js logic.js \
				cram-backplane.csv $(BOARDS)
	./compile -g -C images/CRAM.mem -D images/DRAM.mem
	touch $@

clean:
	@rm -f .compile.build
	@yarnpkg run clean
	@rm -f kl10 $(GENRTLDIR)/*
	@rm -f $(IMAGES)
	@make -C $(RTLDIR) clean
