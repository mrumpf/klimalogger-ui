#!/bin/bash -x

# $1 rrd file
# $2 start timestamp
function create_rrd()
{
rrdtool create $1                    \
            --start $2               \
            DS:T0:GAUGE:600:-50:50   \
            DS:H0:GAUGE:600:0:100    \
            DS:T1:GAUGE:600:-50:50   \
            DS:H1:GAUGE:600:0:100    \
            DS:T2:GAUGE:600:-50:50   \
            DS:H2:GAUGE:600:0:100    \
            DS:T3:GAUGE:600:-50:50   \
            DS:H3:GAUGE:600:0:100    \
            DS:T4:GAUGE:600:-50:50   \
            DS:H4:GAUGE:600:0:100    \
            DS:T5:GAUGE:600:-50:50   \
            DS:H5:GAUGE:600:0:100    \
            RRA:AVERAGE:0.5:1:1440   \
            RRA:MIN:0.5:1:1440       \
            RRA:MAX:0.5:1:1440       \
            RRA:AVERAGE:0.5:30:17520 \
            RRA:MIN:0.5:30:17520     \
            RRA:MAX:0.5:30:17520
}

# $1 rrd file
# $2 file to convert
function convert()
{
while read p; do

time=$(echo $p | tr '|' ' ' | awk '{print $2}')
time_since_epoch=$(date +%s --date $time)
t0=$(echo $p | tr '|' ' ' | awk '{print $3}')
h0=$(echo $p | tr '|' ' ' | awk '{print $4}')
t1=$(echo $p | tr '|' ' ' | awk '{print $5}')
h1=$(echo $p | tr '|' ' ' | awk '{print $6}')
t2=$(echo $p | tr '|' ' ' | awk '{print $7}')
h2=$(echo $p | tr '|' ' ' | awk '{print $8}')
t3=$(echo $p | tr '|' ' ' | awk '{print $9}')
h3=$(echo $p | tr '|' ' ' | awk '{print $10}')
t4=$(echo $p | tr '|' ' ' | awk '{print $11}')
h4=$(echo $p | tr '|' ' ' | awk '{print $12}')
t5=$(echo $p | tr '|' ' ' | awk '{print $13}')
h5=$(echo $p | tr '|' ' ' | awk '{print $14}')

echo "$time_since_epoch:$t0:$h0:$t1:$h1:$t2:$h2:$t3:$h3:$t4:$h4:$t5:$h5"
rrdtool update $1 $time_since_epoch:$t0:$h0:$t1:$h1:$t2:$h2:$t3:$h3:$t4:$h4:$t5:$h5

done < $2
}


function mkgraph()
{
rrdtool graph $1.png                           \
      --start 1257696599 --end 1258185900      \
      --vertical-label "C/H"                   \
      DEF:temp0=$1:T0:AVERAGE                  \
      DEF:hum0=$1:H0:AVERAGE                   \
      DEF:temp1=$1:T1:AVERAGE                  \
      DEF:hum1=$1:H1:AVERAGE
}

#create_rrd tfa.rrd 1257696599
#convert tfa.rrd tfa_dump.csv
mkgraph tfa.rrd 1257696599 1257696599

