This directory contains a work-in-progress pure Dart implementation.

As a user of `ace.dart` you should ignore this implementation for the time 
being.

As a contributor to `ace.dart` you may be interested to contribute to the 
development of this implementation.  It is in the very early stages, but the 
goal is to provide a pure Dart implementation of all the core classes which runs
against the same tests as the proxy implementation as we iterate.  We are 
working to port code from the bottom up of the object dependency graph.

The pluggable types such as `Theme`, `Mode`, etc... will be the last thing we
port.  We want to be able to load the javascript version of these into the pure
Dart implementation.
