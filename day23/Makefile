PROG=part1

ifneq ($(DEBUG),)
    CXXFLAGS += -g -gdwarf-4 -O0
endif

all: part1
	./part1

part1: part1.cc
	$(CXX) -Wall -std=c++11 $(CXXFLAGS) -o $@ $<

clean:
	-rm -rf $(PROG) $(PROG).dSYM
