
PROG := test1
PROG2 := test2
part%.o: part%.asm
	as -arch arm64 -o $@ $<

all: $(PROG) $(PROG2)

$(PROG): part1.o
$(PROG2): part2.o

$(PROG2) $(PROG): test1.c
	gcc -o $@ $^ -g -gdwarf-4 -lc

clean:
	-rm -rf *.o $(PROG).dSYM $(PROG) $(PROG2).dSYM $(PROG2)
