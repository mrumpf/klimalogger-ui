### Prerequisites ###

* xmlstarlet - bash XML parsing
* rrdtool - bash RRD  processing

### Weather Forecast ###
The script bin/weather-forecast.sh retrieves a 4 day forecast from the Google
weather API. It downloads the XML and the referenced images and puts all into
the sub-folder tmp/weather. The XML and the images are used by the
klimalogger-ui to display a 4 day forecast.

### RRD ###


### Crontab ###
1. Wheather Forecast

0 0 * * *   $KLIMALOGGER_HOME/bin/weather-forecast.sh

2. Temperature

*/5 * * * * $KLIMALOGGER_HOME/bin/dump....

### Libraries ###
* jQuery Mobile - http://jquerymobile.com/
* RRDtool - http://oss.oetiker.ch/rrdtool/
* javascriptRRD - http://sourceforge.net/projects/javascriptrrd/

