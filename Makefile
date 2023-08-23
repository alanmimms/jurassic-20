# Top level Makefile for the KL10 with Verilator.

TOPEXE = $(RTLOBJDIR)/kl10pvtb

BOARDS = \
    board/apr.board \
    board/cac.board \
    board/ccl.board \
    board/ccw.board \
    board/cds.board \
    board/ch0a.board \
    board/ch0.board \
    board/ch0x.board \
    board/cha.board \
    board/chc.board \
    board/chx.board \
    board/ci.board \
    board/clk.board \
    board/cnt.board \
    board/con.board \
    board/cra.board \
    board/crc.board \
    board/crm.board \
    board/csh.board \
    board/ctl.board \
    board/dlh.board \
    board/dmc.board \
    board/dps.board \
    board/dt0.board \
    board/dtr.board \
    board/dx0.board \
    board/edp.board \
    board/ignore.board \
    board/int.board \
    board/ird.board \
    board/ma0.board \
    board/mb0.board \
    board/mbc.board \
    board/mbx.board \
    board/mbz.board \
    board/mcl.board \
    board/mtr.board \
    board/pag.board \
    board/pic.board \
    board/pma.board \
    board/scd.board \
    board/shm.board \
    board/vma.board


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
