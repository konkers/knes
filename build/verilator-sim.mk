## Copyright 2014 Brian Swetland <swetland@frotz.net>
##
## Licensed under the Apache License, Version 2.0 
## http://www.apache.org/licenses/LICENSE-2.0

MODULE_NAME := $(strip $(MODULE_NAME))
ifeq ("$(MODULE_NAME)","")
$(error no module name)
endif

MODULE_OBJDIR := sim/$(MODULE_NAME)-vsim
MODULE_RUN := $(MODULE_NAME)-vsim
MODULE_BIN := $(MODULE_OBJDIR)/V$(MODULE_TOP)

MODULE_HEX_SRCS := $(filter %.hex,$(MODULE_SRCS))
MODULE_VLG_SRCS := $(filter-out %.hex,$(MODULE_SRCS))

MODULE_OPTS := --top-module $(MODULE_TOP)
#-Ihdl
MODULE_OPTS += --Mdir $(MODULE_OBJDIR)
MODULE_OPTS += --exe ../../$(MODULE_TESTBENCH)
MODULE_OPTS += --cc
MODULE_OPTS += -DSIMULATION

MODULE_OPTS += -CFLAGS "$(CXXFLAGS) -isystem ../../$(GTEST_INC) -I ../../$(TESTBENCH_INC) -DTRACE"
MODULE_OPTS += -LDFLAGS "../../$(GTEST_LIB) ../../$(TESTBENCH_LIB)"
MODULE_OPTS += --trace

$(MODULE_BIN): _OPTS := $(MODULE_OPTS)
$(MODULE_BIN): _SRCS := $(MODULE_VLG_SRCS)
$(MODULE_BIN): _HEX := $(MODULE_HEX_SRCS)
$(MODULE_BIN): _DIR := $(MODULE_OBJDIR)
$(MODULE_BIN): _NAME := $(MODULE_NAME)
$(MODULE_BIN): _TOP := $(MODULE_TOP)
$(MODULE_BIN): _TESTBENCH := $(MODULE_TESTBENCH)

$(MODULE_BIN): $(MODULE_SRCS) $(MODULE_HEX_SRCS) $(GTEST_LIB) $(TESTBENCH_LIB) $(MODULE_TESTBENCH)
	@mkdir -p $(_DIR) bin
	@for hex in $(_HEX) ; do cp $$hex $(_DIR) ; done
	@echo "COMPILE (verilator): $(_NAME)"
	$(VERILATOR) $(_OPTS) $(_SRCS)
	@echo "COMPILE (C++): $(_NAME)"
	@make -C $(_DIR) -f V$(_TOP).mk

$(MODULE_RUN): _BIN := $(MODULE_BIN)
$(MODULE_RUN): _DIR := $(MODULE_OBJDIR)
$(MODULE_RUN): _TOP := $(MODULE_TOP)

$(MODULE_RUN): $(MODULE_BIN)
	@(cd $(_DIR) && ./V$(_TOP))

ALL_TARGETS += $(MODULE_RUN)
ALL_TESTS += $(MODULE_BIN)
TARGET_$(MODULE_RUN)_DESC := "run verilator simulation"

MODULE_TOP :=
MODULE_TESTBENCH :=
MODULE_NAME :=
MODULE_SRCS :=
