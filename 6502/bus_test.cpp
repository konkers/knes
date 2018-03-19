#include <stdio.h>
#include <testbench.h>

#include "Vbus_test.h"

class BusTest : public Testbench<Vbus_test>
{
  protected:
    void Test(
        uint8_t val0, bool enable0,
        uint8_t val1, bool enable1,
        uint8_t val2, bool enable2,
        uint8_t val3, bool enable3,
        uint8_t pull_downs) {
        dut->driver_values = val0 | (val1 << 8) | (val2 << 16) | (val3 << 24);
        dut->driver_enables = enable0 | (enable1 << 1) | (enable2 << 2) | (enable3 << 3);
        dut->pull_down_enables = pull_downs;
        eval();
        uint8_t expected_val = ~pull_downs;
        if (enable0) {
            expected_val &= val0;
        }
        if (enable1) {
            expected_val &= val1;
        }
        if (enable2) {
            expected_val &= val2;
        }
        if (enable3) {
            expected_val &= val3;
        }

        EXPECT_EQ(expected_val, dut->value);
    }
};

TEST_F(BusTest, Basic) {
    for (int i = 0; i < 0x100; i++) {
        Test(0x0, false, 0xa5, false, 0x5a, false, 0xff, false, i);
        Test(0x0, true, 0xa5, false, 0x5a, false, 0xff, false, i);
        Test(0x0, false, 0xa5, true, 0x5a, false, 0xff, false, i);
        Test(0x0, false, 0xa5, false, 0x5a, true, 0xff, false, i);
        Test(0x0, false, 0xa5, false, 0x5a, false, 0xff, true, i);
    }
}