## Copyright 2014 Brian Swetland <swetland@frotz.net>
##
## Licensed under the Apache License, Version 2.0 
## http://www.apache.org/licenses/LICENSE-2.0

VERILATOR := verilator
VERILATOR_ROOT :=  /Users/konkers/homebrew/Cellar/verilator/3.920/share/verilator

VIVADOPATH := /work/xilinx/Vivado/2014.3
XSDKPATH := /work/xilinx/SDK/2014.3

VIVADO := $(VIVADOPATH)/bin/vivado
XELAB := $(VIVADOPATH)/bin/xelab
XSIM := $(VIVADOPATH)/bin/xsim
XMD := $(XSDKPATH)/bin/xmd

ifeq ("$(VERBOSE)","")
# reduce the firehose of output chatter from Vivado
VIVADO_FILTER := | grep -e "^INFO:.*Inferred" -e "^WARNING:" -e "^ERROR:"
VIVADO_FILTER += | grep -v '\[Board 49-26\]'
endif

ALL_TARGETS :=
ALL_TESTS :=

# default: assume build is adjacent to top level Makefile
BUILD ?= build

CXXFLAGS := -std=c++14 -I$(VERILATOR_ROOT)/include

# gtest library for verilator testbenches
GTEST_DIR := third_party/googletest/googletest
GTEST_LIB := sim/libgtest.a
GTEST_INC := $(GTEST_DIR)/include 
$(GTEST_LIB): $(GTEST_DIR)/src/gtest-all.cc
	$(CXX) $(CXXFLAGS) -isystem $(GTEST_INC) -I$(GTEST_DIR) \
    	-pthread -c $(GTEST_DIR)/src/gtest-all.cc \
    	-o sim/gtest-all.o
	ar -rv sim/libgtest.a sim/gtest-all.o

# testbench support library
TESTBENCH_LIB := sim/libtestbench.a
TESTBENCH_INC := testbench
$(TESTBENCH_LIB): testbench/testbench.cpp
	$(CXX) $(CXXFLAGS) -isystem $(GTEST_INC) \
    	-pthread -c $^ \
    	-o sim/testbench.o
	ar -rv sim/libtestbench.a sim/testbench.o