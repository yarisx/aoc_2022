#!/usr/bin/env python3

f = open("map.txt", "r")
t = open("trail.txt", "r")
m = open("way.txt", "w+")

lines=list()
map=list()
lcnt = 0

for l in range(0, 202):
    mtmp = list()
    for i in range(0, 152):
        mtmp.append(' ')
    map.append(mtmp)

j = 0
for l in f:
    mtmp = []
    l = l.rstrip()
    for i in range(0, len(l)):
        print("i = ", i)
        map[j][i] = (ord(l[i]))
    j = j + 1

for tr in t:
    if not tr.startswith("f:"):
        continue
    [f, x, y] = tr.split(",")
    fs = f.split(":")[1].strip()
    xc = int(x.split(":")[1].strip())
    yc = int(y.split(":")[1].strip())
    print("x ", xc, " y ", yc)
    map[yc][xc] = ord(fs)


for l in map:
    for i in range(0, len(l)):
        if l[i] != ' ':
            m.write('{0}'.format(chr(l[i])))
        else:
            m.write(" ")
    m.write('\n')

