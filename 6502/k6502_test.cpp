#include <testbench.h>

#include "Vk6502.h"

class K6502Test : public Testbench<Vk6502> {
  protected:
	void ClockHigh() {
		dut->ph0 = 1;
		eval();
	}

	void ClockLow() {
		dut->ph0 = 0;
		eval();
	}

	void Clock() {
        ClockLow();
        ClockHigh();
	}
};

TEST_F(K6502Test, Basic) {
    dut->reset_n = 0;
    Clock();
    dut->reset_n = 1;
    for (int i = 0; i < 256; i++) {
        Clock();
    }
}