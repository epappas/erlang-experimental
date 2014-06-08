%%%-------------------------------------------------------------------
%%% @author evangelosp
%%% @copyright (C) 2014, evalonlabs
%%% @doc
%%%
%%% @end
%%%-------------------------------------------------------------------
-module(logger).
-author("evangelosp").

-behaviour(gen_server).

%% API
-export([start/0, stop/0, log/0, log/2]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API
%%%===================================================================

start() ->
  {ok, Pid} = gen_server:start_link({global, ?SERVER}, ?MODULE, [], []),
  true = register(?MODULE, Pid),
  {ok, Pid}.

stop() -> gen_server:call(?MODULE, stop).

log() -> gen_server:call(?SERVER, {test, "TEST"}).

log(_Level, _MSG) -> gen_server:call(?SERVER, {_Level, _MSG}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) -> {ok, ets:new(log_table, [named_table])}.

handle_call(_Request, _From, State) ->
  io:format("~p ~p ~p", [_Request, _From, State]),
  {reply, ok, State}.

handle_cast(_Request, State) -> {noreply, State}.

handle_info(_Info, State) -> {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
