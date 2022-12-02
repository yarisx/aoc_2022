
.DEFAULT_GOAL := all

prepare: input
	cat $< | tr 'A' 'R' | tr 'B' 'P' | tr 'C' 'S' | tr 'X' 'R' | tr 'Y' 'P' | tr 'Z' 'S' > $<.out

calc: input.out
	cat $< | sed -e 's!\(. R\)!\1 + 1!' -e 's!\(. P\)!\1 + 2!' -e 's!\(. S\)!\1 + 3!' > $<.out2

calc2:
	cat $< | sed -e 's!R P\(.*\)!0 + \1!' -e 's!R S

R R
R P
R S
