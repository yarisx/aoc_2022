-module(monkeys).
-export([monkey_op/2, monkey_start_items/1, monkey_test_val/1, monkey_val/2]).
monkey_start_items(0) -> [65, 78];
monkey_start_items(1) -> [54, 78, 86, 79, 73, 64, 85, 88];
monkey_start_items(2) -> [69, 97, 77, 88, 87];
monkey_start_items(3) -> [99];
monkey_start_items(4) -> [60, 57, 52];
monkey_start_items(5) -> [91, 82, 85, 73, 84, 53];
monkey_start_items(6) -> [88, 74, 68, 56];
monkey_start_items(7) -> [54, 82, 72, 71, 53, 99, 67].
monkey_op(0, Old) ->  Old * 3;
monkey_op(1, Old) ->  Old + 8;
monkey_op(2, Old) ->  Old + 2;
monkey_op(3, Old) ->  Old + 4;
monkey_op(4, Old) ->  Old * 19;
monkey_op(5, Old) ->  Old + 5;
monkey_op(6, Old) ->  Old * Old;
monkey_op(7, Old) ->  Old + 1.
monkey_test_val(0) -> 5;
monkey_test_val(1) -> 11;
monkey_test_val(2) -> 2;
monkey_test_val(3) -> 13;
monkey_test_val(4) -> 7;
monkey_test_val(5) -> 3;
monkey_test_val(6) -> 17;
monkey_test_val(7) -> 19.
monkey_val(true, 0) -> 2;
monkey_val(true, 1) -> 4;
monkey_val(true, 2) -> 5;
monkey_val(true, 3) -> 1;
monkey_val(true, 4) -> 7;
monkey_val(true, 5) -> 4;
monkey_val(true, 6) -> 0;
monkey_val(true, 7) -> 6;
monkey_val(false, 0) -> 3;
monkey_val(false, 1) -> 7;
monkey_val(false, 2) -> 3;
monkey_val(false, 3) -> 5;
monkey_val(false, 4) -> 6;
monkey_val(false, 5) -> 1;
monkey_val(false, 6) -> 2;
monkey_val(false, 7) -> 0.
