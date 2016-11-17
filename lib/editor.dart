library editor;

import 'dart:html' as html;
import 'dart:js';
import 'dart:async';
import 'dart:math';

import 'package:ace/ace.dart' as ace;
import 'package:ace/proxy.dart';
import 'package:nest/console.dart';
import 'package:nest/gist.dart';

Random R = new Random();

class Editor {
  ace.Editor _editor;

  Console console = new Console();
  TabBar tabs;
  String get value => _editor.value;

  Editor() {
    tabs = new TabBar(this);

    if (ace.implementation == null)
      ace.implementation = ACE_PROXY_IMPLEMENTATION;

    // Editor Setup
    _editor = ace.edit(html.querySelector("#editor"))
      ..theme = new ace.Theme('ace/theme/wren')
      ..session.mode = new ace.Mode.named(ace.Mode.DART);

    // Check the url to see if we are loading a Gist
    var gistID = html.window.location.href.split('?=');
    if (gistID.length > 1) {
      html.InputElement urlBar = html.querySelector('#url');
      urlBar.value = 'https://gist.github.com/' + gistID[1];

      pullGist(gistID[1]).then((_) {
        for (String key in module.keys) {
          if (key == 'main') {
            tabs.addTab(key);
          }
          else {
            tabs.addTab(key);
          }
        }
        tabs.activateTab('main');
      });
    } else {
      module['main'] = new Module('main', '');
      saveModule();
      tabs.addTab('main');
      tabs.activateTab('main');
    }

    // Controls //
    // Autosaving
    html.querySelector("#editor").onKeyUp.listen((_) {
      saveModule();
    });

    // Run main.wren
    html.querySelector('#run').onClick.listen((_) {
      console.clear();
      JsObject vm = context['vm'];
      vm.callMethod("interpret", [module['main'].content]);
      context['refreshVM'].apply([]);
    });

    html.querySelector('#share').onClick.listen((_) {
      createGist();
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

    // editor configured, hide splash screen
    html.Element splash = html.querySelector('#editor-splash');

    splash.style.opacity = '0.0';
    new Timer(new Duration(milliseconds:250), () => splash.style.display = 'none');
  }

  saveModule() {
    module[tabs.opened].content = _editor.value;
  }
}


class TabBar {
  Editor editor;
  html.Element tabHolder = html.querySelector('#tab-holder');

  TabBar(this.editor) {
    html.Element newTabButton = tabHolder.querySelector('#new-tab');

    newTabButton.onClick.listen((_) {
      String name = rollName();
      module[name] = new Module(name, '// $name.wren');
      addTab(name);
    });
  }

  String rollName() {
    String name = 'f' + R.nextInt(1024).toString();
    if (tabHolder.querySelector('#tab-$name') != null)
      return rollName();
    return name;
  }

  addTab(String name) {
    if (tabHolder.querySelector('#tab-$name') != null) {
      if (name == 'main') {
        tabHolder.querySelector('#tab-main')
        .onClick.listen((_) {
          activateTab(name);
        });
      }
    } else {
      html.Element tab = new html.DivElement()
        ..classes.add('tab')
        ..id = 'tab-$name'
        ..append(
          new html.SpanElement()
            ..className = (name == 'main' ? 'octicon octicon-repo':'octicon octicon-package')
      )
        ..append(
          new html.SpanElement()
            ..className = 'label'
            ..text = name
      )
        ..append(
          new html.SpanElement()
            ..className = 'octicon octicon-x'
      )
        ..onClick.listen((_) => activateTab(name))
        ..onDoubleClick.listen((_) => renameTab(name));

      tab.querySelector('.octicon-x').onClick.listen((_) {
        module[name].rename(null);
        if (opened == name)
          activateTab('main');
        tab.remove();
      });

      tabHolder.append(tab);
    }
  }

  String opened = 'main';
  activateTab(String name) {
    if (tabHolder.querySelector('#tab-$name') == null)
      return;

    opened = name;
    tabHolder.querySelectorAll('*').classes.remove('open');
    tabHolder.querySelector('#tab-$name').classes.add('open');
    editor._editor
      ..setValue(module[name].content)
      ..clearSelection()
      ..navigateTo(0,0);
  }
  renameTab(String name) {
    html.Element tab = tabHolder
    .querySelector('#tab-$name')
    .querySelector('.label');
    tab.classes.toggle('editing');
    tab.contentEditable = 'true';
    tab.focus();

    tab.onKeyPress.listen((event) {
      if (event.keyCode == 13)
        event.preventDefault();
    });


    html.document.onClick.first.then((_) {
      tab.classes.toggle('editing');
      tab.contentEditable = 'false';
      module[name].rename(tab.text);
    });
  }
}
