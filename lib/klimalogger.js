var tmp_data ="tmp/data";
var tmp_weather = "tmp/weather";

function createMenu() {
  for (var i = 0; i < Config.stations.length; i++) {
    document.write('<li><a href="#page' + i + '">' + Current.stations[i]['temp'] + TEMPERATURE_UNIT + ' / ' + Current.stations[i]['humid'] + HUMIDITY_UNIT + ' - ' + Config.stations[i]['name'] + '</a></li>');
  }
}


function createSubPages() {
  for (var i = 0; i < Config.stations.length; i++) {
    document.write('<div data-role="page" id="page' + i + '" data-theme="b" style="background-color: #CCCCCC;background-image: none;">');

    document.write('<div data-role="header">');
    document.write('<a href="#main" data-icon="home" data-iconpos="notext" data-direction="reverse">Home</a>');
    document.write('<h1>' + Config.stations[i]['name'] + '</h1>');
    document.write('</div>');

    document.write('<div data-role="content" data-theme="b">');	

    document.write('<div style="margin:0px auto;width:80%; height:300px;" id="mygraph' + i + '"></div>');	
    document.write('<script language="javascript">drawChart(' + i + ');</script>');	

    document.write('</div>');
	
    document.write('<div data-role="footer" data-theme="b" data-position="fixed">');
    document.write('<h6>(c) 2012 Michael Rumpf</h6>');
    document.write('</div>');
    document.write('</div>');
  }
}

rrd_data = new Array(Current.stations.length);

function draw_graph(idx) {
  var series = [];

  var last_update = rrd_data[idx].getLastUpdate();
  var nrDSs = rrd_data[idx].getNrDSs();
  for (var ds_idx = 0; ds_idx < nrDSs; ds_idx++) {
    var ds = rrd_data[idx].getDS(ds_idx);
    var ds_name = ds.getName();

    var nrRRAs=rrd_data[idx].getNrRRAs();
    for (var i = 0; i < nrRRAs; i++) {
      var rrainfo = rrd_data[idx].getRRAInfo(i);
      var rra = rrd_data[idx].getRRA(i);
      var rows = rra.getNrRows();
      var step = rra.getStep();
      var first_el = last_update - (rows - 1) * step;
      var timestamp = first_el;

      var flot_series = [];
      for (var r = 0; r < rows; r++) {
        var el = rra.getEl(r, ds_idx);
        if (el != undefined) {
          flot_series.push([timestamp * 1000.0, el]);
        }
        timestamp+=step;
      }
      var name = "&#176;C";
      if (ds_name[0] == 'H') {
        name = "%";
      }
      series.push({label: name, data: flot_series, min: first_el * 1000.0, max: last_update * 1000.0});
    }
  }

  var options = { 
    legend: {
      show: true,
      noColumns: 2,
      margin: 10,
      backgroundOpacity: 0.5
    },
    xaxis: {
      mode: "time",
      timeformat: "%d.%m.\n%y"
    },
  };

  var placeholder = $("#mygraph" + idx);
  $.plot(placeholder, series, options);
}

function rrd_load(bf, idx) {
  var rrd_file = undefined;
  try {
    var rrd_file = new RRDFile(bf);            
  } catch(err) {
    alert("File " + bf + " is not a valid RRD archive!");
  }
  if (rrd_file != undefined) {
    rrd_data[idx] = rrd_file;
    draw_graph(idx)
  }
}

function drawChart(idx) {
  fname = tmp_data + "/tfa_" + idx + ".rrd";
  try {
    FetchBinaryURLAsync(fname, rrd_load, idx);
  } catch (err) {
    alert("Failed loading " + fname+"\n" + err);
  }
}

function getForecast() {
  $.get(tmp_weather + "/googleweather.xml",{},function(xml){

	myHTMLOutput = '';
 	myHTMLOutput += '<table width="98%" border="1" cellpadding="0" cellspacing="0">';
  	myHTMLOutput += '<th>Tag</th><th>Temperaturen</th><th>&nbsp;</th>';
  	
        prefix = "/ig/images/weather";
	$('forecast_conditions',xml).each(function(i) {
		var dayOfWeek = $(this).find("day_of_week").attr("data");
		var low = $(this).find("low").attr("data");
		var high = $(this).find("high").attr("data");
		var iconData = $(this).find("icon").attr("data");
                var icon = iconData.substring(prefix.length, iconData.length);
		var condition = $(this).find("condition").attr("data"); 

                mydata = "<tr><td>" + dayOfWeek + "</td><td>" + low + "&deg; - " + high + "&deg; C</td><td><img src=\"" + tmp_weather + "/" + $.trim(icon) + "\"/></td></tr>";
		myHTMLOutput = myHTMLOutput + mydata;
	});
	myHTMLOutput += '</table>';
	
	$("#forecast").append(myHTMLOutput);
  });
}

