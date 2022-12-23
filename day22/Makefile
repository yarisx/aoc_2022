PROG=part1

ifneq ($(DEBUG),)
    CXXFLAGS += -g -gdwarf-4 -O0
endif

all: part1 prepare
	./part1

prepare: input.txt
	cat $< | grep -E '(\.|#)' > map.txt
	cat $< | grep -E '[0-9]+' > trace.txt

part1: part1.cc
	$(CXX) -std=c++11 $(CXXFLAGS) $^ -o $@

clean:
	-rm -rf *.o $(PROG) $(PROG2) $(PROG).dSYM trace.txt map.txt
