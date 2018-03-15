#include "testbench.h"

vluint64_t now = 0;

double sc_time_stamp() {
	return now;
}

int main(int argc, char **argv) {
	::testing::InitGoogleTest(&argc, argv);
	return RUN_ALL_TESTS();
}