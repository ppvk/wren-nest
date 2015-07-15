library editor;

import 'dart:html' as html;
import 'dart:js';

import 'package:ace/ace.dart' as ace;
import 'package:ace/proxy.dart';
import 'package:nest/console.dart';
import 'package:nest/gist.dart';

class Editor {
  ace.Editor _editor;

  Editor() {
    if (ace.implementation == null)
      ace.implementation = ACE_PROXY_IMPLEMENTATION;

    // Check the url to see if we are loading a Gist
    var gistID = html.window.location.href.split('?=');
    if (gistID.length > 1) {
      html.InputElement urlBar = html.querySelector('#url');
      urlBar.value = 'https://gist.github.com/' + gistID[1];

      pullGist(gistID[1]).then((_) {
        if (module['main'] != null) {
          _editor
            ..setValue(module['main'].content)
            ..clearSelection()
            ..navigateTo(0,0);
        }
      });
    }

    // Editor Setup
    _editor = ace.edit(html.querySelector("#editor"))
      ..theme = new ace.Theme('ace/theme/wren')
      ..session.mode = new ace.Mode.named(ace.Mode.DART);

    // JS proxies
    JsFunction interpret =  context['interpret'];
    JsFunction newVM =  context['newVM'];
    JsFunction freeVM =  context['freeVM'];

    // Create starting VM
    newVM.apply([]);

    // Controls
    html.querySelector('#run').onClick.listen((_) {
      interpret.apply(['wren-nest', value]);
    });
    html.querySelector('#reset').onClick.listen((_) {
      console.clear();
      freeVM.apply([]);
      newVM.apply([]);
    });

    html.querySelector('#pull-gist').onClick.listen((_) {
      html.InputElement urlBar = html.querySelector('#url');
      var url = urlBar.value.split('https://gist.github.com/');

      // not a gist
      if (url.length <= 1) {
        print('Invalid Gist url, did you forget the "https://"?');
      }
      else {
        html.window.location.href = html.window.location.href.split('?=').first + '?=' + url[1].split('/').last;
      }
    });
  }



  Console console = new Console();
  String get value => _editor.value;
}