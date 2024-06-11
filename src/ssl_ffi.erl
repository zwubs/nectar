-module(ssl_ffi).

-export([send/2]).

send(Socket, Data) ->
    normalise(ssl:send(Socket, Data)).

normalise(ok) -> {ok, nil};
normalise({ok, T}) -> {ok, T};
normalise({error, {timeout, _}}) -> {error, timeout};
normalise({error, _} = E) -> E.
