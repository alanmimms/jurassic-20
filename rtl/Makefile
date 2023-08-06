EXE = Vmc10101

all:	$(EXE)

Vmc10101:
	verilator -Wall --trace --cc mc10101.sv --exe mc10101-tb.cc
	$(MAKE) -C obj_dir -f $@.mk
