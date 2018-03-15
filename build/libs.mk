# See init.mk for info on these libs.
$(GTEST_LIB): $(GTEST_DIR)/src/gtest-all.cc
	$(CXX) $(CXXFLAGS) -isystem $(GTEST_INC) -I$(GTEST_DIR) \
    	-pthread -c $(GTEST_DIR)/src/gtest-all.cc \
    	-o sim/gtest-all.o
	ar -rv sim/libgtest.a sim/gtest-all.o

$(TESTBENCH_LIB): testbench/testbench.cpp
	$(CXX) $(CXXFLAGS) -isystem $(GTEST_INC) \
    	-pthread -c $^ \
    	-o sim/testbench.o
	ar -rv sim/libtestbench.a sim/testbench.o
