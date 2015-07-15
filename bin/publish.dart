import 'dart:io';
main() async {
  Directory workingDirectory = await new Directory('.').createTemp();
  Directory gitDir = new Directory('.git');
  Directory buildDir = new Directory('build/web');

  if (! await gitDir.exists())
    throw('Project is not a Git directory');

  copyDirectory(gitDir, workingDirectory.path + '/.git');

  print('Checking out gh-pages branch..');
  await Process.run('git', ['checkout', '--orphan', 'gh-pages'], workingDirectory: workingDirectory.path);

  print('Checking out gh-pages branch..');
  await Process.run('git', ['pull', 'origin', 'gh-pages'], workingDirectory: workingDirectory.path);

  print('Clearing old files..');
  await Process.run('git', ['rm', '-rf', '.'], workingDirectory: workingDirectory.path);

  print('Running pub get..');
  await Process.run('pub', ['get'])
  .then((result) {
    print(result.stdout);
    print(result.stderr);
  });

  print('Running pub build..');
  await Process.run('pub', ['build'])
  .then((result) {
    print(result.stdout);
    print(result.stderr);
  });

  copyDirectory(buildDir, workingDirectory.path);

  await Process.run('git', ['add', '--all'], workingDirectory: workingDirectory.path)
  .then((result) {
    print(result.stdout);
    print(result.stderr);
  });

  await Process.run('git', ['status'], workingDirectory: workingDirectory.path)
  .then((result) {
    print(result.stdout);
    print(result.stderr);
  });

  await Process.run('git', ['commit', '-m', new DateTime.now().toIso8601String()], workingDirectory: workingDirectory.path)
  .then((result) {
    print(result.stdout);
    print(result.stderr);
  });

  await Process.run('git', ['push', 'origin', 'gh-pages'], workingDirectory: workingDirectory.path, runInShell: true)
  .then((result) {
    print(result.stdout);
    print(result.stderr);
  });

  await workingDirectory.delete(recursive: true);
}


/// Copy a [Directory]'s contents to a [String] path.
copyDirectory(Directory from, String to) {
  for (File file in from.listSync(recursive: true).where((e) => e is File)) {
    List data = file.readAsBytesSync();

    new File(file.path.replaceAll(from.path, to))
      ..createSync(recursive: true)
      ..writeAsBytesSync(data);
  }
}