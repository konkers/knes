all: list-all-targets

include build/init.mk

MODULE_NAME := alu-test
MODULE_SRCS := \
	6502/alu.sv
MODULE_TESTBENCH := 6502/alu_test.cpp
MODULE_TOP := alu
include build/verilator-sim.mk

MODULE_NAME := bus-bit-test
MODULE_SRCS := \
	6502/bus_bit.sv \
	6502/bus_bit_test.sv
MODULE_TESTBENCH := 6502/bus_bit_test.cpp
MODULE_TOP := bus_bit_test
include build/verilator-sim.mk

MODULE_NAME := bus-test
MODULE_SRCS := \
	6502/bus.sv \
	6502/bus_bit.sv \
	6502/bus_test.sv
MODULE_TESTBENCH := 6502/bus_test.cpp
MODULE_TOP := bus_test
include build/verilator-sim.mk

MODULE_NAME := clockgen-test
MODULE_SRCS := 6502/clockgen.sv
MODULE_TESTBENCH := 6502/clockgen_test.cpp
MODULE_TOP := clockgen
include build/verilator-sim.mk

MODULE_NAME := k6502-test
MODULE_SRCS := \
	6502/alu.sv \
	6502/bus.sv \
	6502/bus_bit.sv \
	6502/clockgen.sv \
	6502/control_signals.sv \
	6502/k6502.sv \
	6502/k6502_data.sv \
	6502/pc_increment.sv \
	6502/register_double_in.sv \
	6502/register_single_in.sv \
	6502/register_triple_in.sv
MODULE_TESTBENCH := 6502/k6502_test.cpp
MODULE_TOP := k6502
include build/verilator-sim.mk

MODULE_NAME := pc-increment-test
MODULE_SRCS := 6502/pc_increment.sv
MODULE_TESTBENCH := 6502/pc_increment_test.cpp
MODULE_TOP := pc_increment
include build/verilator-sim.mk

MODULE_NAME := register-double-in-test
MODULE_SRCS := 6502/register_double_in.sv
MODULE_TESTBENCH := 6502/register_double_in_test.cpp
MODULE_TOP := register_double_in
include build/verilator-sim.mk

MODULE_NAME := register-single-in-test
MODULE_SRCS := 6502/register_single_in.sv
MODULE_TESTBENCH := 6502/register_single_in_test.cpp
MODULE_TOP := register_single_in
include build/verilator-sim.mk

MODULE_NAME := register-triple-in-test
MODULE_SRCS := 6502/register_triple_in.sv
MODULE_TESTBENCH := 6502/register_triple_in_test.cpp
MODULE_TOP := register_triple_in
include build/verilator-sim.mk

clean::
	rm -rf sim synth out

list-all-targets::
	@echo buildable targets:
	@for x in $(ALL_TARGETS) ; do echo $$x ; done

.phony: run-all-tests
run-all-tests: $(ALL_TESTS)
	@go run ./run_tests.go --verbose $(ALL_TESTS)