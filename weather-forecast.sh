#!/bin/bash -x

# uses xmlstarlet

BASE_URL=http://www.google.com

rm -rf weather
mkdir weather
wget -O weather/googleweather.xml "$BASE_URL/ig/api?weather=71032-Germany&hl=de"
iconv -f iso8859-1 -t utf-8 weather/googleweather.xml > weather/googleweather2.xml
img=$(xmlstarlet sel -t -m "//icon" -v "@data" -nl weather/googleweather2.xml)
pushd weather
for i in $img
do
  echo $i
  wget $BASE_URL$i
done
popd

