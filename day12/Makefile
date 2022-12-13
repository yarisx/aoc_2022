PROG=ospf

DEBUG ?= false
ifeq ($(DEBUG),true)
    CXXFLAGS += -g -gdwarf-4
endif

all: part1 part2

part1: $(PROG) prep1

prep1: input.txt.part1
	cp input.txt.part1 input.txt

prep2:
	./enum_as.py

part2: $(PROG) prep2
	@for i in $$(seq 0 146); \
	do \
		cp input.$$i.txt input.txt; \
		./ospf | grep 'Path length' | grep -v 'length: 1' | cut -d: -f2 ; \
	done | sort -u | head -1

$(PROG): ospf.cc
	g++ -o $@ $<

clean:
	rm $(PROG) input.*.txt
