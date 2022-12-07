
PROG := test1
part1.o:
	as -arch arm64 -o part1.o part1.asm

all: $(PROG)

$(PROG): part1.o test1.c
	gcc -o $@ $^ -g -gdwarf-4 -lc

clean:
	-rm -rf *.o $(PROG).dSYM $(PROG)
