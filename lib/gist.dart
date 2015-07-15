library gist;
import 'dart:html';
import 'dart:js';
import 'dart:convert';

/// Takes all files in the gist and makes them available as Modules to the wren VM.
pullGist(String id) async {
  String src = await HttpRequest.getString('https://api.github.com/gists/' + id);
  Map gist = JSON.decode(src);

  for (String filename in gist['files'].keys) {
    String name = filename.split('.')[0];
    String content = await HttpRequest.getString(gist['files'][filename]['raw_url']);
    module[name] = new Module._(name, content);
  }
}


Map module = new Map();

/// Represents a wren document
/// automatically writes changes to the JsObject that wren imports.
class Module {
  String _name;
  String _value;

  Module._(final this._name, String value) {
    content = value;
  }

  String get content => _value;
  set content(String value) {
    _value = value;
    context['setModule'].apply([_name, content]);
  }
}