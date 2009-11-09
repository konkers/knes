IVERILOG=iverilog
VVP=vvp

GTKWAVE=gtkwave
CA65=ca65
LD65=ld65


all: k6502_test.vcd


.PHONY: tests

ASM_TESTS=${wildcard tests/*.S}
TXT_TESTS=${ASM_TESTS:.S=.txt}
TESTS=${ASM_TESTS:.S=}

tests: ${TXT_TESTS}
	${IVERILOG} -DTRACE -Wall -y. -o k6502_test k6502_test.v
	@for test in ${TESTS}; do \
		cp $$test.txt rom.txt; \
		${VVP} -n ./k6502_test | grep -v "VCD info" > $$test-out.csv; \
		rm rom.txt; \
		diff $$test-out.csv $$test-pass.csv > /dev/null; \
		if [ "$$?" == "0" ]; then \
			echo "$$test: pass"; \
		else \
			echo "$$test: fail"; \
		fi \
	done

dumper: dumper.o

%_test: %_test.v

%.vcd: %
	${VVP} -n ./$<

view-%: %.vcd
	gtkwave -a `echo $< | sed 's/.vcd/.sav/'` $<

%.o: %.S
	${CA65} -t nes -o $@ $<

%.nes: %.o
	${LD65} -t nes -o $@ $<

%.txt: %.nes
	./dumper < $< > $@