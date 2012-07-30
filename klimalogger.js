
function createMenu() {
  for (var i = 0; i < Config.stations.length; i++) {
    document.write('<li><a href="#page' + i + '">' + Current.stations[i]['temp'] + TEMPERATURE_UNIT + ' / ' + Current.stations[i]['humid'] + HUMIDITY_UNIT + ' - ' + Config.stations[i]['name'] + '</a></li>');
  }
}


function createPages() {
  for (var i = 0; i < Config.stations.length; i++) {
    document.write('<div data-role="page" id="page' + i + '" data-theme="a">');

    document.write('<div data-role="header">');
    document.write('<a href="#main" data-icon="home" data-iconpos="notext" data-direction="reverse">Home</a>');
    document.write('<h1>' + Config.stations[i]['name'] + '</h1>');
    document.write('</div>');

    document.write('<div data-role="content" data-theme="a">');	

    document.write('<script language="javascript">draw(' + i + ');</script>');	
    document.write('<div style="width:100%; height:300px;" id="mygraph' + i + '"></div>');	

    document.write('</div>');
	
    document.write('<div data-role="footer">');
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
      timeformat: "%y/%m/%d"
    }
  };
  $.plot($("#mygraph" + idx), series, options);
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

function draw(idx) {
  fname = "tfa_" + idx + ".rrd";
  try {
    FetchBinaryURLAsync(fname, rrd_load, idx);
  } catch (err) {
    alert("Failed loading " + fname+"\n" + err);
  }
}

