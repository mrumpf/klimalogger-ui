#!/bin/bash -x

# uses xmlstarlet

LOC=$1
if [ -z "$LOC" ]
then
  LOC=71032-Germany
fi

if [ -z "$KLIMALOGGER_HOME" ]
then
  KLIMALOGGER_HOME=.
fi

BASE_URL=http://www.google.com
BASE_DIR=$KLIMALOGGER_HOME/tmp/weather

rm -rf $BASE_DIR
mkdir -p $BASE_DIR
# get the weather XML
wget -O $BASE_DIR/googleweather.xml "$BASE_URL/ig/api?weather=$LOC&hl=de"
# convert to utf-8 and extract the data attribute from the icon tag
images=$(iconv -f iso8859-1 -t utf-8 $BASE_DIR/googleweather.xml | xmlstarlet sel -t -m "//icon" -v "@data" -nl)
# get the images
pushd $BASE_DIR
for i in $images
do
  echo $i
  wget $BASE_URL$i
done
popd

