PROG = test1
PROG2 = test2

DEBUG ?= true

ifeq ($(DEBUG), true)
    CFLAGS += -g -gdwarf-4
endif

all: run

run: prepare $(PROG) $(PROG2)
	time ./test1
	time ./test2

test%: test%.o part%.o
	gcc $(CFLAGS) -o $@ $^

test%.o: test%.c
	gcc $(CFLAGS) -c $< -o $@

part%.o: part%.asm
	as -arch arm64 -o $@ -c $<

prepare:
	cat ./input.txt.orig | sed -E 's!noop!0!' | sed -E 's!addx (.*)!0\n\1!' > input.txt

clean:
	-rm -f *.o $(PROG) $(PROG2) input.txt
