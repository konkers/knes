#include <testbench.h>

#include "Valu.h"

class AluTest : public Testbench<Valu> {
  protected:
  void ResetState() {
	  dut->a_in = 0;
	  dut->b_in = 0;
	  dut->decimal_enable = 0;
	  dut->carry_in = 0;
	  dut->sum_en = 0;
	  dut->and_en = 0;
	  dut->eor_en = 0;
	  dut->or_en = 0;
	  dut->shift_en = 0;
  }

  void TestAdd(uint8_t a, uint8_t b, uint8_t carry_in) {
	  ResetState();
	  dut->a_in = a;
	  dut->b_in = b;
	  dut->carry_in = carry_in;
	  dut->sum_en = 1;
	  eval();

	  uint16_t result = a + b + (carry_in & 0x1);
	  uint8_t half_carry =
		  ((a & 0xf) + (b & 0xf) + (carry_in & 0x1)) >> 4;
	  uint8_t data_out = result & 0xff;
	  uint8_t carry = result >> 8;

	  EXPECT_EQ(data_out, dut->data_out);
	  EXPECT_EQ(carry, dut->carry);
	  EXPECT_EQ(half_carry, dut->half_carry);
  }

  void TestAnd(uint8_t a, uint8_t b) {
	  ResetState();
	  dut->a_in = a;
	  dut->b_in = b;
	  dut->and_en = 1;
	  eval();

	  EXPECT_EQ(a & b, dut->data_out);
	  EXPECT_EQ(0, dut->carry);
	  EXPECT_EQ(0, dut->half_carry);
  }

  void TestEor(uint8_t a, uint8_t b) {
	  ResetState();
	  dut->a_in = a;
	  dut->b_in = b;
	  dut->eor_en = 1;
	  eval();

	  EXPECT_EQ(a ^ b, dut->data_out);
	  EXPECT_EQ(0, dut->carry);
	  EXPECT_EQ(0, dut->half_carry);
  }

  void TestOr(uint8_t a, uint8_t b) {
	  ResetState();
	  dut->a_in = a;
	  dut->b_in = b;
	  dut->or_en = 1;
	  eval();

	  EXPECT_EQ(a | b, dut->data_out);
	  EXPECT_EQ(0, dut->carry);
	  EXPECT_EQ(0, dut->half_carry);
  }

  void TestShift(uint8_t a, uint8_t carry_in) {
	  ResetState();
	  dut->a_in = a;
	  dut->carry_in = carry_in;
	  dut->shift_en = 1;
	  eval();

	  uint8_t result = (a  >> 1) | (carry_in << 7);

	  EXPECT_EQ(result, dut->data_out);
	  EXPECT_EQ(a & 0x1, dut->carry);
  }
};

TEST_F(AluTest, Sum) {
	uint8_t numbers[] = {0x00, 0x5a, 0xa5, 0xff};
	for (auto a : numbers) {
		for (auto b : numbers) {
			TestAdd(a, b, 0);
			TestAdd(a, b, 1);
		}
	}
}

TEST_F(AluTest, And) {
	uint8_t numbers[] = {0x00, 0x5a, 0xa5, 0xff};
	for (auto a : numbers) {
		for (auto b : numbers) {
			TestAnd(a, b);
			TestAnd(a, b);
		}
	}
}

TEST_F(AluTest, Eor) {
	uint8_t numbers[] = {0x00, 0x5a, 0xa5, 0xff};
	for (auto a : numbers) {
		for (auto b : numbers) {
			TestEor(a, b);
			TestEor(a, b);
		}
	}
}

TEST_F(AluTest, Or) {
	uint8_t numbers[] = {0x00, 0x5a, 0xa5, 0xff};
	for (auto a : numbers) {
		for (auto b : numbers) {
			TestOr(a, b);
			TestOr(a, b);
		}
	}
}

TEST_F(AluTest, Shift) {
	uint8_t numbers[] = {0x00, 0x5a, 0xa5, 0xff};
	for (auto a : numbers) {
		for (auto b : numbers) {
			TestShift(a, 0);
			TestShift(a, 1);
		}
	}
}

TEST_F(AluTest, Overflow) {
	// Test cases from http://www.6502.org/tutorials/vflag.html
	
	// CLC      ; 1 + 1 = 2, returns V = 0
	// LDA #$01
    // ADC #$01
	TestAdd(1, 1, 0);
	EXPECT_EQ(0, dut->overflow);

    // CLC      ; 1 + -1 = 0, returns V = 0
    // LDA #$01
    // ADC #$FF
	TestAdd(1, 0xff, 0);
	EXPECT_EQ(0, dut->overflow);

    // CLC      ; 127 + 1 = 128, returns V = 1
    // LDA #$7F
    // ADC #$01
	TestAdd(0x7f, 0x01, 0);
	EXPECT_EQ(1, dut->overflow);

    // CLC      ; -128 + -1 = -129, returns V = 1
    // LDA #$80
    // ADC #$FF
	TestAdd(0x80, 0xff, 0);
	EXPECT_EQ(1, dut->overflow);

    // SEC      ; 0 - 1 = -1, returns V = 0
    // LDA #$00
    // SBC #$01
	TestAdd(0x00, -1, 0);
	EXPECT_EQ(0, dut->overflow);

    // SEC      ; -128 - 1 = -129, returns V = 1
    // LDA #$80
    // SBC #$01
	TestAdd(0x80, -1, 0);
	EXPECT_EQ(1, dut->overflow);

    // SEC      ; 127 - -1 = 128, returns V = 1
    // LDA #$7F
    // SBC #$FF
	TestAdd(0x7f, 1, 0);
	EXPECT_EQ(1, dut->overflow);
}

