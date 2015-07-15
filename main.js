// I'm a dart developer, not a JavaScript developer. :/


// hide warning if user has already seen it.
if (localStorage['close-warning'] == 'true') {
  document.querySelector('#warning').style.display = 'none';
}
document.querySelector('#warning .close-button').onclick = function() {
  localStorage['close-warning'] = 'true';
  document.querySelector('#warning').style.display = 'none';
}


// Editor Setup
var editor = ace.edit("editor");
editor.setTheme("ace/theme/wren");
editor.getSession().setMode("ace/mode/dart");

// Fake Console Setup
var aceConsole = ace.edit("console");
aceConsole.setTheme("ace/theme/wren");
aceConsole.setReadOnly(true);
aceConsole.setShowPrintMargin(false);
aceConsole.setHighlightActiveLine(false);
aceConsole.renderer.setShowGutter(false);
var console = {};
console.log = function(text) {
  aceConsole.setValue( aceConsole.getValue() + '' + text + '\n');
  aceConsole.clearSelection();
}


// Listeners
newVM();
document.querySelector('#run').onclick = function() {
  interpret("wren-nest", editor.getValue());
}
document.querySelector('#reset').onclick = function() {
  aceConsole.setValue('');
  freeVM();
  newVM();
}


// Pull in URL
var gistID = window.location.href.split('?=')[1];
if (gistID != undefined) {
  document.querySelector('#url').value = 'https://gist.github.com/' + gistID;

  // TODO do github api stuff here.

  getGists(gistID);
}


var module = new Map();

function getGists(id) {
  var getUrl = 'https://api.github.com/gists/' + id;
  var get = new XMLHttpRequest();
      get.open( "GET", getUrl, true );
      get.send();
  get.onreadystatechange = function() {
    if (get.readyState == 4 && get.status == 200) {
      var gists = JSON.parse(get.responseText);
      editor.setValue(gists['files']['main.wren']['content']);
      for (var file in gists.files) {
          var mod = file.split('.')[0];
          module[mod] = gists.files[file].content;
      }
      editor.clearSelection();
      editor.navigateTo(0,0);
    }
  }
}




// update the gist
document.querySelector('#pull-gist').onclick = function() {
  var urlTail = document.querySelector('#url').value.split('https://gist.github.com/')[1]
  // not a gist
  if (urlTail == undefined) {
    console.log('Invalid Gist url, did you forget the "https://"?');
  }
  // gist without username
  else if (urlTail.split('/')[1] == undefined) {
    gistID = urlTail;
    console.log('gistID changed to:' + gistID);
    window.location.href = window.location.href.substring(0, window.location.href.indexOf('?=')) + '?=' + gistID;
  }
  // gist with username
  else {
    gistID = urlTail.split('/')[1];
    console.log('gistID changed to:' + gistID);
    window.location.href = window.location.href.substring(0, window.location.href.indexOf('?=')) + '?=' + gistID;
  }
}
