#!/usr/bin/env python3

lines = 41

f = open("input.txt.orig", "r")
ln = 0

a_pos=[]
flines = []

def count_as(l, start):
    counter = 0
    for c in l:
        if c == 'a':
            a_pos.append([start, counter])
        counter = counter + 1


for dl in f:
    l = dl.strip()
    if ln == 0:
        count_as(l, 0)
    elif ln == lines - 1:
        count_as(l, ln)
    else:
        if l[0] == 'a':
            a_pos.append([ln, 0])
        if l[-1] == 'a':
            a_pos.append([ln, -1])
    ln = ln + 1
    flines.append(l.replace('S', 'a'))


linelen = len(flines[0])
prefixline = '*' * (linelen + 1)

for (counter, [linenum, linepos]) in enumerate(a_pos):
    o = open("input.{0}.txt".format(counter), "w+")
    lc = 0
    o.write('{0}\n'.format(prefixline))
    for l in flines:
        if linenum == lc:
            if linepos != -1:
                newl = l[:linepos] + 'S' + l[linepos + 1:]
            else:
                newl = l[:-1] + 'S'
        else:
            newl = l
        o.write('*{0}\n'.format(newl))
        lc = lc + 1
    o.write('{0}\n'.format(prefixline))
    counter = counter + 1
