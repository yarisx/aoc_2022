#!/usr/bin/env python3

import input

order = 0
cnt = 0

def comp(l, r):
    if type(l) == type([]) and type(r) == type(l):
    #    print("Comparing lists: {0} vs {1}".format(l, r))
        return comp_list(l, r)
    if type(l) == type(1) and type(r) == type(1):
    #    print("Comparing ints: {0} vs {1}".format(l, r))
        if l < r:
    #        print("result 2")
            return 2
        elif l > r:
    #        print("result 0")
            return 0
        else:
    #        print("result 1")
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
    #        print("cmp result ", cmp)
            return cmp
        else:
            continue
    if ll < lr:
    #    print("result 2")
        return 2
    elif ll > lr:
    #    print("result 0")
        return 0
    else:
    #    print("result 1")
        return 1

idx = list()
for i in range(0, len(input.a)):
    l = input.a[i]
    r = input.b[i]
    order = comp(l, r)
    #print("Order ", order)
    if order == 2:
        idx.append(i + 1)

print("Pairs: ", sum(idx))
