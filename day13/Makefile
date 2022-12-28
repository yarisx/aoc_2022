
prepare:
	cat input.txt | awk 'BEGIN {print "a = list()\nb = list()\n"; }; /\[/ { if (NR % 3 == 1) { print "a.append(", $$0, ")"; } else if (NR %3 == 2) { print "b.append(", $$0, ")"}; };' > input.py
