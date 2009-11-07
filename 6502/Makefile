IVERILOG=iverilog
VVP=vvp

GTKWAVE=gtkwave
CA65=ca65
LD65=ld65


tests: k6502_test.vcd

dumper: dumper.o

%_test: %_test.v
	${IVERILOG} -Wall -y. -o $@ $<

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