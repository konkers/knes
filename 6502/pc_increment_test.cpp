#include <testbench.h>

#include "Vpc_increment.h"

class PcIncrementTest : public Testbench<Vpc_increment> {
  private:
    void HalfInc(uint8_t inc, uint8_t *value, uint8_t *carry) {
		*value += inc;
		*carry = *value >> 4;
		*value = *value & 0xf;
	}

  protected:
	void TestValue(uint8_t value, uint8_t increment) {
		dut->data_in = value;
		dut->increment = increment;
		eval();
		
		uint8_t low_half = value & 0xf;
		uint8_t high_half = value >> 4;
		uint8_t low_carry;
		uint8_t high_carry;

		HalfInc(increment, &low_half, &low_carry);
		HalfInc(low_carry, &high_half, &high_carry);

		uint16_t new_value = (value + increment) & 0xff;
		EXPECT_EQ(new_value, (high_half << 4) | low_half );
		EXPECT_EQ(new_value, dut->data_out);
		EXPECT_EQ(high_carry, dut->carry_out);
		EXPECT_EQ(low_carry, dut->half_carry_out);
	}
};

TEST_F(PcIncrementTest, Full) {
	for (int i = 0; i < 0x100; i++) {
		TestValue(i, 0);
		TestValue(i, 1);
	}
}