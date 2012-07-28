
function createMenu() {
  for (var i = 0; i < Config.stations.length; i++) {
    document.write('<li><a href="#page' + i + '">' + Config.stations[i]['name'] + '</a></li>');
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

    document.write('</div>');
	
    document.write('<div data-role="footer">');
    document.write('<h4>(c) 2012 Michael Rumpf</h4>');
    document.write('</div>');
    document.write('</div>');
  }
}
