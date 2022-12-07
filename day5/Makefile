

all: prepare
	cd day5 && stack run

prepare: moves.d.txt init_stacks.txt

moves.d.txt init_stacks.txt: input.txt
	./split_init.sh

clean:
	cd day5 && stack purge
	rm init* moves*
