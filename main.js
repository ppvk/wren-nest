// I'm a dart developer, not a JavaScript developer. :/

// Editor Setup
var editor = ace.edit("editor");
editor.setTheme("ace/theme/katzenmilch");
editor.getSession().setMode("ace/mode/dart");

// Fake Console Setup
var aceConsole = ace.edit("console");
aceConsole.setTheme("ace/theme/katzenmilch");
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
  document.querySelector('#url').value = 'https://gist.github.com/ppvk/' + gistID;
}

document.querySelector('#url').onchange = function() {
  var urlTail = document.querySelector('#url').value.split('https://gist.github.com/')[1]
  if (urlTail == undefined) {
    console.log('Invalid Gist url, did you forget the "https://"?');
  }
  else {
    urlTail.split('/')[1];
    console.log('gistID changed to:' + gistID);
  }
}
