MODS = mc10101 mc10103 mc10104 mc10105 mc10107

.PHONY:	all clean

all:	$(MODS)

$(MODS):
	$(MAKE) -f module.mk MODULE=$@

clean:
	@rm -fr obj_dir
