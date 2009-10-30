IVERILOG=iverilog
GTKWAVE=gtkwave

tests: k6502_test.vcd

%_test: %_test.v
	${IVERILOG} -y. -o $@ $<

%.vcd: %
	./$<

view-%: %.vcd
	gtkwave -a `echo $< | sed 's/.vcd/.sav/'` $<