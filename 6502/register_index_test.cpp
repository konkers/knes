#include <testbench.h>

#include "Vregister_index.h"

class RegisterIndexTest : public Testbench<Vregister_index> {
  protected:
	uint8_t Read() {
		dut->bus_enable = 1;
		dut->load = 0;
		eval();
		return dut->data;
	}

	void WriteTest(uint8_t value) {
		dut->bus_enable = 0;
		dut->data = value;
		dut->load = 1;
		eval();
		dut->bus_enable = 1;
		dut->load = 0;
		eval();
		EXPECT_EQ(value, dut->data);
	}
};

TEST_F(RegisterIndexTest, Basic) {
	EXPECT_EQ(0x00, Read());

	WriteTest(0xff);
	WriteTest(0xa5);
	WriteTest(0x5a);
	WriteTest(0x00);
}