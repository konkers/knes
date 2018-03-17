#include <testbench.h>

#include "Vregister_triple_in.h"

class RegisterTripleInTest : public Testbench<Vregister_triple_in> {
  protected:
	void TestValue(int bus, uint8_t value) {
		dut->load0 = 0;
		dut->load1 = 0;
		dut->load2 = 0;
		eval();

		dut->data_in0 = bus == 0 ? value : ~value;
		dut->data_in1 = bus == 1 ? value : ~value;
		dut->data_in2 = bus == 2 ? value : ~value;
		dut->load0 = bus == 0;
		dut->load1 = bus == 1;
		dut->load2 = bus == 2;
		eval();

		EXPECT_EQ(value, dut->data_out);
	}
};

TEST_F(RegisterTripleInTest, BasicBus0) {
	TestValue(0, 0xff);
	TestValue(0, 0xa5);
	TestValue(0, 0x5a);
	TestValue(0, 0x00);
}

TEST_F(RegisterTripleInTest, BasicBus1) {
	TestValue(1, 0xff);
	TestValue(1, 0xa5);
	TestValue(1, 0x5a);
	TestValue(1, 0x00);
}

TEST_F(RegisterTripleInTest, BasicBus2) {
	TestValue(2, 0xff);
	TestValue(2, 0xa5);
	TestValue(2, 0x5a);
	TestValue(2, 0x00);
}