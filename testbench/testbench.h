#pragma once

#include <fcntl.h>
#include <gtest/gtest.h>
#include <sys/types.h>
#include <unistd.h>

#include "verilated.h"
#include <verilated_vcd_c.h>

extern vluint64_t now;

template<class T>
class Testbench : public ::testing::Test {
  public:
	static constexpr const char *vcdName = "trace.vcd";

  protected:
	Testbench() {
		// No good way to handle Verilated::commandArgs(argc, argv) now.
		Verilated::debug(0);
		Verilated::randReset(2);

		dut = new T;
		Verilated::traceEverOn(true);
		tfp = new VerilatedVcdC;
		dut->trace(tfp, 99);
		tfp->open(vcdName);
	}

	virtual ~Testbench() {
		tfp->close();
		dut->final();
		delete dut;
	}

	void eval() {
		dut->eval();
		tfp->dump(now);
		now += 5;
	}

	T *dut;
	VerilatedVcdC* tfp;
};