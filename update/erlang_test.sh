cd $(dirname $0)

echo "Compiling erlang pgm"
erlc erlang_test.erl
echo "------------------"

echo "Executing erlang pgm"
erl -noshell -s erlang_test  start -s init stop
