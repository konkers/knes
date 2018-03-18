#include <testbench.h>

#include "Vregister_pc.h"

class RegisterPcTest : public Testbench<Vregister_pc>
{
  protected:
    void TestValue(uint8_t value)
    {
        // Reset inputs to known state.
        dut->load = 0;
        dut->bus_enable0 = 0;
        dut->bus_enable1 = 0;
        dut->data_in = 0x00;
        eval();
        EXPECT_EQ(0x0, dut->data_out0);
        EXPECT_EQ(0x0, dut->data_out1);

        // Load value.
        dut->data_in = value;
        dut->load = 1;
        eval();

        dut->load = 1;

        for (int i = 0; i < 4; i++) {
            dut->bus_enable0 = i & (1 << 0);
            dut->bus_enable1 = i & (1 << 1);

            eval();

            EXPECT_EQ(value, dut->pc_out);
            EXPECT_EQ(dut->bus_enable0 ? value : 0x0, dut->data_out0);
            EXPECT_EQ(dut->bus_enable1 ? value : 0x0, dut->data_out1);
        }
    }
};

TEST_F(RegisterPcTest, Basic)
{
    TestValue(0xff);
    TestValue(0xa5);
    TestValue(0x5a);
    TestValue(0x00);
}