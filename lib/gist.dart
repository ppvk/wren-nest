library gist;
import 'dart:html';
import 'dart:js';
import 'dart:convert';
import 'package:transmit/transmit.dart';

/// Takes all files in the gist and makes them available as Modules to the wren VM.
pullGist(String id) async {
  String src = await HttpRequest.getString('https://api.github.com/gists/' + id);
  Map gist = JSON.decode(src);

  for (String filename in gist['files'].keys) {
    String name = filename.split('.')[0];
    String content = await HttpRequest.getString(gist['files'][filename]['raw_url']);
    module[name] = new Module(name, content);
  }
}

createGist() async {
  Map post = {
    "description": "Wren Snippet : Created at http://ppvk.github.io/wren-nest",
    "public": true,
    "files": {
    }
  };
  for (Module mod in module.values) {
    if (mod._name != null) {
      post['files'][mod._name + '.wren'] = {
        'content': mod.content
      };
    }
  }

  HttpRequest request = new HttpRequest();
  await request.open('POST', 'https://api.github.com/gists');
  request.onLoad.first.then((event) {
    Map response = JSON.decode(event.target.responseText);
    String permalink = window.location.href.split('?=').first + '?=' + response['id'];
    transmit('console-clear');
    transmit('console',
    'Permalink to current snapshot:\n========================\n$permalink\n========================');
  });
  request.send(JSON.encode(post));
}


Map module = new Map();

/// Represents a wren document
/// automatically writes changes to the JsObject that wren imports.
class Module {
  String _name;
  String _value;

  Module(this._name, String value) {
    content = value;
  }

  String get content => _value;
  set content(String value) {
    _value = value;
    context['setModule'].apply([_name, content]);
  }

  rename(String newName) {
    context['setModule'].apply([newName, content]);
    context['setModule'].apply([_name, null]);
    this._name = newName;
  }
}
