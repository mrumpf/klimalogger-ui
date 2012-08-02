#!/bin/bash -x

if [ -z "$KLIMALOGGER_HOME" ]
then
  KLIMALOGGER_HOME=.
fi

BASE_DIR=$KLIMALOGGER_HOME/tmp/data

# $1 rrd file
# $2 start timestamp
function create_rrd()
{
	echo "### Creating RRD..."
	# 365 * 24 = 8760
	rrdtool create $BASE_DIR/$1_0.rrd             \
		    --start $2              \
		    DS:T0:GAUGE:600:U:U     \
		    DS:H0:GAUGE:600:U:U     \
		    RRA:AVERAGE:0.5:12:8760

	rrdtool create $BASE_DIR/$1_1.rrd             \
		    --start $2              \
		    DS:T1:GAUGE:600:U:U     \
		    DS:H1:GAUGE:600:U:U     \
		    RRA:AVERAGE:0.5:12:8760

	rrdtool create $BASE_DIR/$1_2.rrd             \
		    --start $2              \
		    DS:T2:GAUGE:600:U:U     \
		    DS:H2:GAUGE:600:U:U     \
		    RRA:AVERAGE:0.5:12:8760

	rrdtool create $BASE_DIR/$1_3.rrd             \
		    --start $2              \
		    DS:T3:GAUGE:600:U:U     \
		    DS:H3:GAUGE:600:U:U     \
		    RRA:AVERAGE:0.5:12:8760

	rrdtool create $BASE_DIR/$1_4.rrd             \
		    --start $2              \
		    DS:T4:GAUGE:600:U:U     \
		    DS:H4:GAUGE:600:U:U     \
		    RRA:AVERAGE:0.5:12:8760

	rrdtool create $BASE_DIR/$1_5.rrd             \
		    --start $2              \
		    DS:T5:GAUGE:600:U:U     \
		    DS:H5:GAUGE:600:U:U     \
		    RRA:AVERAGE:0.5:12:8760
}

# $1 rrd file
# $2 file to convert
function convert()
{
	echo "### Creating CSV and feeding to RRD..."
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
		rrdtool updatev $BASE_DIR/$1_0.rrd $time_since_epoch:$t0:$h0
		rrdtool updatev $BASE_DIR/$1_1.rrd $time_since_epoch:$t1:$h1
		rrdtool updatev $BASE_DIR/$1_2.rrd $time_since_epoch:$t2:$h2
		rrdtool updatev $BASE_DIR/$1_3.rrd $time_since_epoch:$t3:$h3
		rrdtool updatev $BASE_DIR/$1_4.rrd $time_since_epoch:$t4:$h4
		rrdtool updatev $BASE_DIR/$1_5.rrd $time_since_epoch:$t5:$h5

	done < $2
}


function mkgraph()
{
	echo "### Making graph from RRD..."
	rrdtool graph $BASE_DIR/$1_$2.png --slope-mode                     \
	      --start $3 --end $4                                \
	      DEF:temp${2}avg=$BASE_DIR/$1_$2.rrd:T${2}:AVERAGE               \
	      DEF:hum${2}avg=$BASE_DIR/$1_$2.rrd:H${2}:AVERAGE                \
	      LINE1:temp${2}avg#000000:"Durchschnittstemperatur" \
	      LINE1:hum${2}avg#00FF00:"Durchschnittsluftfeuchtigkeit"
}

create_rrd klimalogger 1257696590
convert klimalogger $KLIMALOGGER_HOME/klimalogger_dump.csv
mkgraph klimalogger 0 1257696590 1258185910
mkgraph klimalogger 1 1257696590 1258185910
mkgraph klimalogger 2 1257696590 1258185910
mkgraph klimalogger 3 1257696590 1258185910
mkgraph klimalogger 4 1257696590 1258185910
mkgraph klimalogger 5 1257696590 1258185910

