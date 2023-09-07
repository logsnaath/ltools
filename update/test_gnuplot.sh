cd $(dirname $0);

rm -f xy.png sinx.png 2> /dev/null
gnuplot test_gnuplot.p

file *.png

