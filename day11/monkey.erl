-module(monkey).
-export([init/1, spawn_tribe/1]).

-record(monkey_state,{
            item_list = [],
            next_monkey,
            oper,
            test_val,
            true_val,
            false_val,
            activity = 0
        }).

num_to_name(0) -> zero;
num_to_name(1) -> one;
num_to_name(2) -> two;
num_to_name(3) -> three;
num_to_name(4) -> four;
num_to_name(5) -> five;
num_to_name(6) -> six;
num_to_name(7) -> seven.

init([List, Oper, TestVal, TrueVal, FalseVal]) ->
    TrueMonkeyName = num_to_name(TrueVal),
    FalseMonkeyName = num_to_name(FalseVal),
    MS = #monkey_state{
                  item_list = List,
                  oper = Oper,
                  test_val = TestVal,
                  true_val = TrueMonkeyName,
                  false_val = FalseMonkeyName},
    run(MS).

run(#monkey_state{item_list = ItemList,
                    next_monkey = NP,
                    activity = Activity} = MS) ->
    receive
        die ->
            whereis('monkey_king') ! {activity, Activity},
            NP ! die,
            ok;
        {next_monkey, P} ->
            run(MS#monkey_state{next_monkey = P});
        {store, Item} ->
            NewMS = MS#monkey_state{item_list = ItemList ++ [Item]},
            run(NewMS);
        toss ->
            NewActivity = process_items(MS),
            NP ! toss,
            run(MS#monkey_state{activity = Activity + NewActivity, item_list = []})
    end.

process_items(#monkey_state{
                item_list = ItemList,
                oper = OperF,
                test_val = TestVal,
                true_val = TrueVal,
                false_val = FalseVal
              }) ->
    lists:foreach(fun(I) -> test(OperF, TestVal, TrueVal, FalseVal, I) end, ItemList),
    length(ItemList).


test(F, TestVal, TrueVal, FalseVal, Item) ->
    NewItem = F(Item) div 3,
    case NewItem rem TestVal of
        0 ->
            TruePid = whereis(TrueVal),
            TruePid ! {store, NewItem};
        _ ->
            FalsePid = whereis(FalseVal),
            FalsePid ! {store, NewItem}
    end,
    ok.

spawn_tribe(Steps) ->
    erlang:register('monkey_king', self()),
    SpawnFun = fun(I) ->
        spawn(fun() ->
        MonkeyOp = fun(Old) -> monkeys:monkey_op(I, Old) end,
        monkey:init([monkeys:monkey_start_items(I), MonkeyOp,
                     monkeys:monkey_test_val(I),
                     monkeys:monkey_val(true, I),
                     monkeys:monkey_val(false, I)])
        end)
    end,
    MonkeyPids = lists:map(fun(I) -> SpawnFun(I) end, [0,1,2,3,4,5,6,7]),
    lists:foreach(fun({P, I}) ->
        Name = num_to_name(I),
        erlang:register(Name, P)
    end, lists:zip(MonkeyPids, [0,1,2,3,4,5,6,7])),
    NextMonkeyPids = tl(MonkeyPids) ++ [self()],
    lists:foreach(fun({P, N}) -> P ! {next_monkey, N} end, lists:zip(MonkeyPids, NextMonkeyPids)),
    start(Steps, hd(MonkeyPids)).

start(0, First) ->
    First ! die,
    collect_loop([]);
start(R, First) ->
    io:format("Round ~p~n", [R]),
    First ! toss,
    receive
        toss -> ok
    end,
    start(R - 1, First).

collect_loop(R) when length(R) == 8 ->
    SL = lists:reverse(lists:sort(R)),
    HD1 = hd(SL),
    HD2 = hd(tl(SL)),
    HD1 * HD2;
collect_loop(Res) ->
    receive
        {activity, A} ->
            collect_loop([A|Res])
    end.
