#include <testbench.h>

#include "Vregister_single_in.h"

class RegisterSingleInTest : public Testbench<Vregister_single_in> {
  protected:
	RegisterSingleInTest() {
	}

	virtual ~RegisterSingleInTest() {
	}
	
	void TestValue(uint8_t value) {
		dut->load = 0;
		eval();

		dut->data_in = value;
		dut->load = 1;
		eval();

		EXPECT_EQ(value, dut->data_out);
	}
};

TEST_F(RegisterSingleInTest, Basic) {
	TestValue(0xff);
	TestValue(0xa5);
	TestValue(0x5a);
	TestValue(0x00);
}