%%%-------------------------------------------------------------------
%%% @author evangelosp
%%% @copyright (C) 2014, evalonlabs.com
%%% @doc
%%%
%%% @end
%%% Created : 29. May 2014 23:27
%%%-------------------------------------------------------------------
-module(test).
-author("evangelosp").

%% API
-export([start/0]).

start() ->
  spawn(fun() -> loop() end).

loop() ->
  receive
    hello ->
      io:format("Hello, World!~n"),
      loop();

    goodbye ->
      ok
  end.