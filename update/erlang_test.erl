% hello erlang program
-module(erlang_test). 
-export([start/0]). 

start() -> 
   io:fwrite("Hello, erlang!\n").
