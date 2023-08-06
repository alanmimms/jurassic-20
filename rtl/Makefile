MODULE = mc10101
EXE = V$(MODULE)

.PHONY:	all clean

all:	$(EXE)

$(EXE):	obj_dir/$(EXE).mk
	$(MAKE) -C obj_dir -f $@.mk

obj_dir/$(EXE).mk:
	verilator -Wall --trace --cc $(MODULE).sv --exe $(MODULE)-tb.cc

clean:
	@rm -fr obj_dir
