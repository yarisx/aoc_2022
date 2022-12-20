PROG    = part1
PROG2   = part2

ifneq ($(DEBUG),)
    CFLAGS += -g -gdwarf-4 -O0
endif

all: $(PROG) $(PROG2)
	$(PROG) $(PROG2)

part%: part%.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	-rm -rf $(PROG) $(PROG).dSYM
