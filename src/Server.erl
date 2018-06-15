%%%-------------------------------------------------------------------
%%% @author Joe
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Mar 2017 11:44 AM
%%%-------------------------------------------------------------------
-module('Server').
-author("Joe").

%% API
-export([test/2]).
universal_server() ->
  receive
    {become, F} ->
      F()
  end.
lucas_server() ->
  receive
    {From, N} ->
      From ! lucas(N),
      lucas_server()
  end.
lucas(0) -> 2;
lucas(1) -> 1;
lucas(N) -> lucas(N-1) + lucas(N-2).
fibonacci_server()->
  receive
    {From, N} ->
      From ! fibonacci(N),
      fibonacci_server()
  end.
fibonacci(0) -> 1;
fibonacci(1) -> 1;
fibonacci(N) -> fibonacci(N-1) + fibonacci(N-2).
factorial_server() ->
  receive
    {From, N} ->
      From ! factorial(N),
      factorial_server()
  end.

factorial(0) -> 1;
factorial(N) -> N * factorial(N-1).
golden_ratio_server() ->
  receive
    {From, N} ->
      From ! golden_ratio(N),
      golden_ratio_server()
  end.
golden_ratio(0) -> 1;
golden_ratio(1) -> 2;
golden_ratio(N) -> fibonacci(N-1)/fibonacci(N-2).
test(N, Mode) ->
  Pid = spawn(fun universal_server/0),
  if
    Mode == 0 -> Pid ! {become, fun factorial_server/0};
    Mode == 1 -> Pid ! {become, fun lucas_server/0};
    Mode == 2 -> Pid ! {become, fun golden_ratio_server/0};
    true -> Pid! {become, fun fibonacci_server/0}
  end,
  Pid ! {self(), N},
  receive
    X -> X
  end.
