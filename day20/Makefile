PROG    = part1

ifneq ($(DEBUG),)
    CFLAGS += -g -gdwarf-4 -O0
endif

ifneq ($(PART2),)
    CFLAGS += -DPART2
endif

all: dopart1 dopart2

dopart1:
	$(MAKE) clean
	$(MAKE) part1
	./part1

dopart2:
	$(MAKE) clean
	PART2=true $(MAKE) part1
	./part1

part%: part%.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	-rm -rf $(PROG) $(PROG).dSYM
