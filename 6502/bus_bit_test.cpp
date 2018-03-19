#include <stdio.h>
#include <testbench.h>

#include "Vbus_bit_test.h"

class BusBitTest : public Testbench<Vbus_bit_test>
{
  protected:
  void DoTest(uint8_t enables, uint8_t values) {
      uint8_t expected = 1;
      for (int i = 0; i < 4; i++) {
          uint8_t mask = 1 << i;
          if (enables & mask) {
              expected &= values & mask ? 1 : 0;
          }
      }

      dut->driver_enable = enables;
      dut->driver_value = values;
      eval();
      EXPECT_EQ(expected, dut->out);
  }
};

TEST_F(BusBitTest, Basic)
{
    for (uint8_t enables = 0; enables < (1 << 4); enables++) {
        for (uint8_t values = 0; values < (1 << 4); values++) {
            DoTest(enables, values);
        }
    }
}