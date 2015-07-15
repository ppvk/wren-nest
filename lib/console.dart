library console;

import 'dart:html';

import 'package:ace/ace.dart' as ace;
import 'package:ace/proxy.dart';
import 'package:transmit/transmit.dart';

/// A wrapper for the ace.js console
/// TODO make interactive
class Console {
  ace.Editor _console;
  Console() {
    if (ace.implementation == null)
      ace.implementation = ACE_PROXY_IMPLEMENTATION;

    // Fake Console Setup
    _console = ace.edit(querySelector("#console"))
      ..theme = new ace.Theme("ace/theme/wren")
      ..readOnly = true
      ..showPrintMargin = false
      ..highlightActiveLine = false
      ..renderer.showGutter = false;

    new Service(['console'], (text) {
      _console
        ..setValue( _console.value + '' + text + '\n')
        ..clearSelection()
        ..gotoPageDown();
    });
  }

  /// Clear the console.
  clear() {
    _console.setValue('');
  }

  String get value => _console.value;
}