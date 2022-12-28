#!/usr/bin/env python3

import input
from functools import cmp_to_key

order = 0
cnt = 0

def comp(l, r):
    if type(l) == type([]) and type(r) == type(l):
        return comp_list(l, r)
    if type(l) == type(1) and type(r) == type(1):
        if l < r:
            return 2
        elif l > r:
            return 0
        else:
            return 1
    else:
        return comp_ineq(l, r)

def comp_ineq(l, r):
    if type(l) == type([]):
        return comp(l, [r])
    else:
        return comp([l], r)

def comp_list(l, r):
    ll = len(l)
    lr = len(r)
    for i in range(0, min(ll, lr)):
        cmp = comp(l[i], r[i])
        if cmp != 1:
            return cmp
        else:
            continue
    if ll < lr:
        return 2
    elif ll > lr:
        return 0
    else:
        return 1

idx = list()
for i in range(0, len(input.a)):
    l = input.a[i]
    r = input.b[i]
    order = comp(l, r)
    if order == 2:
        idx.append(i + 1)

input.a.extend(input.b)
input.a.append([[2]])
input.a.append([[6]])
def comparator(l, r):
    return 1 - comp(l, r)
la = sorted(input.a, key = cmp_to_key(comparator))

print("Pairs: ", sum(idx))
f = la.index([[2]]) + 1
l = la.index([[6]]) + 1
print("Idx: ", f * l)
