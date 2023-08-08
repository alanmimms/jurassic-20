MODULE ?= define-MODULE-or-this-happens
LOGICDIR = logic
TBDIR = tb
EXE = V$(MODULE)

.PHONY:	all clean

all:	$(EXE)

$(EXE):	obj_dir/$(EXE).mk
	$(MAKE) -C obj_dir -f $@.mk

obj_dir/$(EXE).mk:
	verilator -Wall --trace --cc $(LOGICDIR)/$(MODULE).sv --exe $(TBDIR)/$(MODULE)-tb.cc

clean:
	@rm -fr obj_dir
