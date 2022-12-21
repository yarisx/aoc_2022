#!/usr/bin/env python3

yf = open("input.txt", "r")
hf = open("day21/src/Yell.hs", "w+")

hf.write("module Yell\n( root ) where\n")

for y in yf:
    [fn, op] = y.split(':')
    hf.write("{0} :: Int\n".format(fn))
    if op.strip().isdigit():
        hf.write("{0} = {1}\n".format(fn, op.strip()))
    else:
        [l, s, r] = op.strip().split(" ")
        if s == "/":
            s = "` div `"
        hf.write("{0} = {1} {3} {2}\n".format(fn, l, r, s))
