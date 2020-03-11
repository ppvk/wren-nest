# the Wren nest
wren-nest is a web application written (mostly) in Dart, for running and sharing snippets of [wren](http://wren.io) code.

Under the hood, wren-nest uses [wrenjs](https://github.com/ppvk/wrenjs). This means you have built in access to the JS module.
Documentation for the JS module can be found [here](https://github.com/ppvk/wrenjs).

## Current Features
1. Runs wren in the browser
2. Imports Gists from GitHub, treating 'main.wren' as an entrypoint
3. Modules, can be 'import'ed from other files in the Gist
4. Saves to anonymous Gists

## Planned Features
1. Importing other Gists as Modules
2. Fun modules for drawing graphs or adding UI components