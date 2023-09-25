# data filename
data=lsbench.dat

# remove the file extension from ${data}
data=$(echo ${data} | cut -d'.' -f1)
datafile="${data}.dat"
epsfile="${data}.eps"
echo "datafile:" ${datafile}
echo "epsfile:" ${epsfile}

# fontsize of fig
fontsize=25

# =====================
# 一个x标签对应多少个colum
alg_c=5.3

# x标签的中心位置偏移
x_label_center_offset=1

# 每个x标签与x标签之间的空白间隙
gap_width=1.15

# x标签的个数
number_of_x_label_type=8

# 有效内容距离边框上下左右的边距（不是画幅的长度）
top_margin=1.0
bottom_margin=2.8
left_margin=7.5
right_margin=2.0

# y轴的最小最大值
y_min=100
y_max=36000000

# 填充图案
tcm_pattern=6
timing_pattern=2
rf_pattern=4
calig_pattern=1

# =====================

# gunplot command
cmd="
set term postscript enhanced eps ${fontsize}
set output \"${epsfile}\"

set tmargin ${top_margin}
set bmargin ${bottom_margin}
set lmargin ${left_margin}
set rmargin ${right_margin}

set xrange [ -1: ${alg_c}*${number_of_x_label_type}-1]

set xtics font \"Helvetica, ${fontsize}\"
set xtics ( \"q_{5s}\" 0*${alg_c}+${x_label_center_offset}, \"q_{10s}\" 1*${alg_c}+${x_label_center_offset}, \"q_{15s}\" 2*${alg_c}+${x_label_center_offset}, \"q_{20s}\" 3*${alg_c}+${x_label_center_offset}, \"q_{5d}\" 4*${alg_c}+${x_label_center_offset}, \"q_{10d}\" 5*${alg_c}+${x_label_center_offset}, \"q_{15d}\" 6*${alg_c}+${x_label_center_offset}, \"q_{20d}\" 7*${alg_c}+${x_label_center_offset} ) rotate by -17
set xlabel offset 0, 0 font \"Helvetica, ${fontsize}\"


set yrange [${y_min}: ${y_max}]
set logscale y
set ytics ( \"10^2\" 100, \"10^3\" 1000, \"10^4\" 10000, \"10^5\" 100000, \"10^6\" 1000000, \"INF\" 3600000 )
set ylabel \"Running Time (ms)\" offset 0.5 font \"Helvetica, ${fontsize}\"


set boxwidth 1

# =====start multiplot=======
set multiplot
set origin 0, 0
set size 1, 1

set key top horizontal center

plot '$datafile' using ((\$1)-1)*${alg_c}+0*${gap_width}:(\$2) title \"TC-Match\" with boxes fill pattern ${tcm_pattern} lt 1 lw 2,\
'$datafile' using ((\$1)-1)*${alg_c}+1*${gap_width}:(\$3) title \"Timing\" with boxes fill pattern ${timing_pattern} lt 1 lw 2,\
'$datafile' using ((\$1)-1)*${alg_c}+2*${gap_width}:(\$4) title \"RapidFlow\" with boxes fill pattern ${rf_pattern} lt 1 lw 2,\
'$datafile' using ((\$1)-1)*${alg_c}+3*${gap_width}:(\$5) title \"CaLiG\" with boxes fill pattern ${calig_pattern} lt 1 lw 2


# plot '$datafile' using ((\$1)-1)*${alg_c}+0*${gap_width}:(\$3) title \"TC-Match\" with boxes fill pattern 6 lt 1 lw 2,\
# '$datafile' using ((\$1)-1)*${alg_c}+1*${gap_width}:(\$5) title \"Timing\" with boxes fill pattern 2 lt 1 lw 2,\
# '$datafile' using ((\$1)-1)*${alg_c}+2*${gap_width}:(\$7) title \"RapidFlow\" with boxes fill pattern 4 lt 1 lw 2


# set key off

# replot '$datafile' using ((\$1)-1)*${alg_c}+0*${gap_width}:(\$2) title \"TC-Match\" with boxes fill pattern 3 lt 1 lw 2,\
# '$datafile' using ((\$1)-1)*${alg_c}+1*${gap_width}:(\$4) title \"Timing\" with boxes fill pattern 3 lt 1 lw 2,\
# '$datafile' using ((\$1)-1)*${alg_c}+2*${gap_width}:(\$6) title \"RapidFlow\" with boxes fill pattern 3 lt 1 lw 2


unset multiplot
# =====end multiplot=======
"

# execute gnuplot command
echo "$cmd" | gnuplot

# transform *.eps to *.pdf
epstopdf ${epsfile}
