#!/bin/bash

start=0

# Split the input into initial state and moves
DELIM_LINE="$(grep -En '^$' input.txt | tr -d ':')"
head -n ${DELIM_LINE} input.txt > init.txt
grep 'move' input.txt > moves.txt

# Massage the initial state data into more machine-readable
echo -n "1 " > init1.txt
cat init.txt | grep -Eo '^(.){3,4}' | grep -Ev '^ *$' | tr -d '[' | tr -d ']' | tr -d ' ' | tr '\n' ' ' | sed 's! *[0-9].*!!' >> init1.txt
for n in $(seq 2 9)
do
    right=$(( $((n - 1)) * 4))
    left=$(( $right - 1))
    echo -n "$n " > init${n}.txt
    cat init.txt | sed -E "s!.{$left,$right}!!" | grep -Eo '^(.){3,4}' | grep -Ev '^ *$' | tr  -d '[' | tr  -d ']' | tr -d ' '|  tr '\n' ' ' | sed 's! *[0-9].*!!' >> init${n}.txt
done

rm -f init_stacks.txt
for f in $(seq 1 9); do cat init${f}.txt >> init_stacks.txt; echo "" >> init_stacks.txt; done

cat moves.txt | sed -E 's!move !!g' | sed -E 's! from!!g' | sed -E 's! to!!g' > moves.d.txt
