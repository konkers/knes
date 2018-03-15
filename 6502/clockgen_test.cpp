#include <testbench.h>

#include "Vclockgen.h"

class ClockgenTest : public Testbench<Vclockgen> {
  protected:
};

TEST_F(ClockgenTest, Basic) {
    dut->ph0 = 0;
    eval();
	EXPECT_EQ(1, dut->ph1);
	EXPECT_EQ(1, dut->ph1_out);
	EXPECT_EQ(0, dut->ph2);
	EXPECT_EQ(0, dut->ph2_out);

    dut->ph0 = 1;
    eval();
	EXPECT_EQ(0, dut->ph1);
	EXPECT_EQ(0, dut->ph1_out);
	EXPECT_EQ(1, dut->ph2);
	EXPECT_EQ(1, dut->ph2_out);

    dut->ph0 = 0;
    eval();
	EXPECT_EQ(1, dut->ph1);
	EXPECT_EQ(1, dut->ph1_out);
	EXPECT_EQ(0, dut->ph2);
	EXPECT_EQ(0, dut->ph2_out);
}
