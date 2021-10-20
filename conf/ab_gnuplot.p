# Let's output to a jpeg file
set terminal png size 1920,1280
# This sets the aspect ratio of the graph
set size 1,0.7
# The file we'll write to
set output "bench.jpg"
# The graph title
set title "ab -n 100 000 -c 1000 '-H Accept-Encoding: gzip, deflate' -rk"
# Where to place the legend/key
set key left top
# Draw gridlines oriented on the y axis
set grid y
# Specify that the x-series data is time data
set xdata time
# Specify the *input* format of the time data
set timefmt "%s"
# Specify the *output* format for the x-axis tick labels
set format x "%S"
# Label the x-axis
set xlabel 'seconds'
# Label the y-axis
set ylabel "response time (ms)"
# Tell gnuplot to use tabs as the delimiter instead of spaces (default)
set datafile separator '\t'
# Plot the data
plot "out.data" every ::2 using 2:5 title 'response time' with points
exit
