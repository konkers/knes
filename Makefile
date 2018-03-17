all: list-all-targets

include build/init.mk

MODULE_NAME := clockgen-test
MODULE_SRCS := 6502/clockgen.sv
MODULE_TESTBENCH := 6502/clockgen_test.cpp
MODULE_TOP := clockgen
include build/verilator-sim.mk

MODULE_NAME := input-data-latch-test
MODULE_SRCS := 6502/input_data_latch.sv
MODULE_TESTBENCH := 6502/input_data_latch_test.cpp
MODULE_TOP := input_data_latch
include build/verilator-sim.mk

MODULE_NAME := k6502-test
MODULE_SRCS := \
	6502/clockgen.sv \
	6502/input_data_latch.sv \
	6502/k6502.sv \
	6502/register_ac.sv \
	6502/register_adder_hold.sv \
	6502/register_index.sv \
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

MODULE_NAME := register-adder-hold-test
MODULE_SRCS := 6502/register_adder_hold.sv
MODULE_TESTBENCH := 6502/register_adder_hold_test.cpp
MODULE_TOP := register_adder_hold
include build/verilator-sim.mk

MODULE_NAME := register-ac-test
MODULE_SRCS := 6502/register_ac.sv
MODULE_TESTBENCH := 6502/register_ac_test.cpp
MODULE_TOP := register_ac
include build/verilator-sim.mk

MODULE_NAME := register-index-test
MODULE_SRCS := 6502/register_index.sv
MODULE_TESTBENCH := 6502/register_index_test.cpp
MODULE_TOP := register_index
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
	@for x in $(ALL_TESTS); do \
		echo ; \
		echo "Running $$x"; \
		./$$x; \
    done