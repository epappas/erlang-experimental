-module(smtpd_app).

-behaviour(application).

-export([start/0, start/2, stop/1]).

-define(DEFAULT_PORT, 2525).

start() ->
  start({}, {}).

start(_Type, _StartArgs) ->
  logger:start(),
  % open listen socket here, avoiding adding code to supervisors
  Port = case application:get_env(tcp_interface, port) of
           {ok, P} -> P;
           undefined -> ?DEFAULT_PORT
         end,
  {ok, LSock} = gen_tcp:listen(Port, [{active, true}, {packet, line}, {reuseaddr, true}]),

  {ok, Hostname} = inet:gethostname(),

  % start supervisor
  case smtpd_sup:start_link({LSock, Hostname}) of
    {ok, Pid} ->
      io:format("server started~n"),
      % start first accept server
      smtpd_sup:start_child(),
      {ok, Pid};
    Other ->
      {error, Other}
  end.

stop(_State) ->
  ok.
