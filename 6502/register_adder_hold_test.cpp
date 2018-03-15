#include <testbench.h>

#include "Vregister_adder_hold.h"

class RegisterAdderHoldTest : public Testbench<Vregister_adder_hold> {
  protected:
	void TestValue(uint8_t value) {
		dut->load = 0;
		dut->bus_enable0 = 0;
		dut->bus_enable1_0_6 = 0;
		dut->bus_enable1_7 = 0;
		eval();

		dut->data_in = value;
		dut->load = 1;
		eval();
		dut->load = 0;

		EXPECT_EQ(0x00, dut->data_out0);
		EXPECT_EQ(0x00, dut->data_out1);

		dut->bus_enable0 = 1;
		eval();
		EXPECT_EQ(value, dut->data_out0);
		EXPECT_EQ(0x00, dut->data_out1);

		dut->bus_enable0 = 0;
		dut->bus_enable1_0_6 = 1;
		dut->bus_enable1_7 = 0;
		eval();
		EXPECT_EQ(0x00, dut->data_out0);
		EXPECT_EQ(value & 0x7f, dut->data_out1);

		dut->bus_enable0 = 0;
		dut->bus_enable1_0_6 = 0;
		dut->bus_enable1_7 = 1;
		eval();
		EXPECT_EQ(0x00, dut->data_out0);
		EXPECT_EQ(value & 0x80, dut->data_out1);

		dut->bus_enable0 = 0;
		dut->bus_enable1_0_6 = 1;
		dut->bus_enable1_7 = 1;
		eval();
		EXPECT_EQ(0x00, dut->data_out0);
		EXPECT_EQ(value, dut->data_out1);
	}
};

TEST_F(RegisterAdderHoldTest, Basic) {
	TestValue(0xff);
	TestValue(0xa5);
	TestValue(0x5a);
	TestValue(0x00);
}