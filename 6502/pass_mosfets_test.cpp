#include <stdio.h>
#include <testbench.h>

#include "Vpass_mosfets.h"

class PassMosfetsTest : public Testbench<Vpass_mosfets>
{
  protected:
    void DoTest(
      uint8_t input0, uint8_t input1,
      bool driven0, bool driven1,
      bool pass_enable,
      uint8_t expected0, uint8_t expected1) {
        dut->bus_input = input0 | (input1 << 8);
        dut->bus_driven = driven0 | (driven1 << 1);
        dut->pass_enable = pass_enable;

        eval();

        EXPECT_EQ(expected0, dut->bus_output & 0xff);
        EXPECT_EQ(expected1, dut->bus_output >> 8);
    }
};

TEST_F(PassMosfetsTest, Basic) {
  DoTest(0xa5, 0x5a, true, true, false, 0xa5, 0x5a);
  DoTest(0xa5, 0x5a, true, false, true, 0xa5, 0xa5);
  DoTest(0xa5, 0x5a, false, true, true, 0x5a, 0x5a);
}