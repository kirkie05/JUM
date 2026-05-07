import 'dart:io';
import 'dart:convert';

void main() async {
  final buildFile = File('.dart_tool/build/entrypoint/build.dart');
  if (!await buildFile.exists()) {
    print('Generating build.dart by running build_runner...');
    final process = await Process.start('dart', ['run', 'build_runner', 'build', '--delete-conflicting-outputs']);
    await Future.delayed(Duration(seconds: 10));
    process.kill();
  }

  if (await buildFile.exists()) {
    print('Modifying build.dart to resolve duplicate import prefix...');
    var content = await buildFile.readAsString();
    content = content.replaceAll(
      "import 'package:build_runner/src/bootstrap/processes.dart' as _build_runner;",
      "import 'package:build_runner/src/bootstrap/processes.dart' as _build_runner_bootstrap;",
    );
    content = content.replaceAll(
      "_build_runner.ChildProcess.run",
      "_build_runner_bootstrap.ChildProcess.run",
    );
    await buildFile.writeAsString(content);
    print('Successfully fixed build.dart!');

    print('Running custom build compilation in real-time...');
    final runProcess = await Process.start('dart', ['.dart_tool/build/entrypoint/build.dart', 'build', '--delete-conflicting-outputs']);
    
    runProcess.stdout.transform(utf8.decoder).transform(LineSplitter()).listen((line) {
      print('STDOUT: $line');
    });
    
    runProcess.stderr.transform(utf8.decoder).transform(LineSplitter()).listen((line) {
      print('STDERR: $line');
    });

    final exitCode = await runProcess.exitCode;
    print('Build finished with exit code: $exitCode');
  } else {
    print('Failed to locate build.dart!');
  }
}
