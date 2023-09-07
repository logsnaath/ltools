
#set encoding utf8
#set terminal postscript enhanced solid color
#set output
#set terminal X11

set title "XY Plot"
set output "xy.png"
set terminal png size 500,500
plot x+x

set title 'Sin(x)'
set output "sinx.png"
set terminal png size 500,500
plot sin(x)

