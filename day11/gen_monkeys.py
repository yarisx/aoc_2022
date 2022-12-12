#!/usr/bin/env python3

f = open("input.txt")
o = open("day11/src/Monkeys._", "w+")
o2 = open("monkeys.erl", "w+")

o.write("module Monkeys\n")
o.write("    (\n")
o.write("      monkeyStartItems,\n")
o.write("      monkeyOp,\n")
o.write("      monkeyTest,\n")
o.write("      monkeyThrow\n")
o.write("    ) where\n")

o2.write("-module(monkeys).\n")
o2.write("-export([monkey_op/2, monkey_start_items/1, monkey_test_val/1, monkey_val/2]).\n")

monkey_num = -1
monkey_items = list()
monkey_op = list()
monkey_test = list()
monkey_true = list()
monkey_false = list()

for dl in f:
    l = dl.strip()
    if l.startswith("Monkey"):
        monkey_num = ord(l.split(' ')[1][0]) - ord('0')
    if l.startswith("Starting"):
        ditems = l.split(':')[1].strip().split(',')
        items = []
        for i in ditems:
            items.append(int(i))
        monkey_items.append(items)
    if l.startswith("Operation"):
        fun = l.split(':')[1].strip()
        monkey_op.append(fun)
    if l.startswith("Test"):
        test = int(l.split(':')[1].strip().split(' ')[2])
        monkey_test.append(test)
    if l.startswith("If true"):
        true = int(l.split(' ')[5])
        monkey_true.append(true)
    if l.startswith("If false"):
        false = int(l.split(' ')[5])
        monkey_false.append(false)

monkey_num = monkey_num + 1
for m in range (0, monkey_num):
    o.write("monkeyStartItems {0} = {1}\n".format(m, monkey_items[m]))
    o2.write("monkey_start_items({0}) -> {1};\n".format(m, monkey_items[m]))

for m in range (0, monkey_num):
    o.write("monkeyOp {0} old = new `div` 3\n    where {1}\n".format(m, monkey_op[m]))
    o2.write("monkey_op({0}, Old) -> {1};\n".format(m, monkey_op[m].replace('new =', '').replace('old', 'Old')))

for m in range (0, monkey_num):
    o.write("monkeyTest {0} old = monkeyThrow {0} testres\n    where testres = (old `div` {1} == 0)\n".format(m, monkey_test[m]))
    o2.write("monkey_test_val({0}) -> {1};\n".format(m, monkey_test[m]))

for m in range (0, monkey_num):
    o.write("monkeyThrow {0} True = {1}\n".format(m, monkey_true[m]))
    o2.write("monkey_val(true, {0}) -> {1};\n".format(m, monkey_true[m]))

for m in range (0, monkey_num):
    o.write("monkeyThrow {0} False = {1}\n".format(m, monkey_false[m]))
    o2.write("monkey_val(false, {0}) -> {1};\n".format(m, monkey_false[m]))
