#include <testbench.h>

#include "Vregister_double_in.h"

class RegisterDoubleInTest : public Testbench<Vregister_double_in> {
  protected:
	void TestValue(int bus, uint8_t value) {
		dut->load0 = 0;
		dut->load1 = 0;
		eval();

		dut->data_in0 = bus == 0 ? value : ~value;
		dut->data_in1 = bus == 1 ? value : ~value;
		dut->load0 = bus == 0;
		dut->load1 = bus == 1;
		eval();

		EXPECT_EQ(value, dut->data_out);
	}
};

TEST_F(RegisterDoubleInTest, BasicBus0) {
	TestValue(0, 0xff);
	TestValue(0, 0xa5);
	TestValue(0, 0x5a);
	TestValue(0, 0x00);
}

TEST_F(RegisterDoubleInTest, BasicBus1) {
	TestValue(1, 0xff);
	TestValue(1, 0xa5);
	TestValue(1, 0x5a);
	TestValue(1, 0x00);
}