
# data filename
data=test.dat

# remove the file extension from ${data}
data=`echo ${data} | cut -d'.' -f1` #
datafile="${data}.dat"
epsfile="${data}.eps"
echo "datafile:" ${datafile}
echo "epsfile:" ${epsfile}

# fontsize of fig
fontsize=35

# number of x axes label type
alg_c=4

# gunplot command
cmd="
set term postscript enhanced eps ${fontsize}
set output \"${epsfile}\"

set tmargin 1.0
set bmargin 2.8
set lmargin 7.5
set rmargin 1

set xrange [ -1: ${alg_c}*4-1]

set xtics font \"Helvetica, ${fontsize}\"
set xtics ( \"5\" +1, \"10\" ${alg_c}+1, \"15\" 2*${alg_c}+1, \"20\" 3*${alg_c}+1 ) 
set xlabel \"Query Size (Number of Edges)\" offset 0, 0.4 font \"Helvetica, ${fontsize}\"


set yrange [100: 36000000]
set logscale y
set ytics ( \"10^2\" 100, \"10^3\" 1000, \"10^4\" 10000, \"10^5\" 100000, \"INF\" 3600000 )
set ylabel \"Running Time (ms)\" offset 0.5 font \"Helvetica, ${fontsize}\"

set key left top

set boxwidth 1

# =====start multiplot=======
set multiplot
set origin 0, 0
set size 1, 1

plot '$datafile' using ((\$1)-1)*${alg_c}+0:(\$2)+(\$3) title \"tu\" with boxes fill pattern 1 lt 1 lw 2,\
'$datafile' using ((\$1)-1)*${alg_c}+1:(\$4)+(\$5) title \"tiu\" with boxes fill pattern 2 lt 1 lw 2,\
'$datafile' using ((\$1)-1)*${alg_c}+2:(\$6)+(\$7) title \"ru\" with boxes fill pattern 3 lt 1 lw 2


replot '$datafile' using ((\$1)-1)*${alg_c}+0:(\$2) title \"ts\" with boxes fill pattern 4 lt 1 lw 2,\
'$datafile' using ((\$1)-1)*${alg_c}+1:(\$4) title \"tis\" with boxes fill pattern 5 lt 1 lw 2,\
'$datafile' using ((\$1)-1)*${alg_c}+2:(\$6) title \"rs\" with boxes fill pattern 6 lt 1 lw 2

unset multiplot
# =====end multiplot=======
"

# execute gnuplot command
echo "$cmd" | gnuplot

# transform *.eps to *.pdf
epstopdf ${epsfile}
