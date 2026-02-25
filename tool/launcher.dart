// ignore_for_file: avoid_print, document_ignores
import 'dart:io';

/// Smart launcher for modern Flutter projects
void main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart run tool/launcher.dart [ios|android]');
    exit(1);
  }

  final platform = args[0].toLowerCase();

  print('Looking for $platform emulator...');
  final emulatorsResult = await Process.run('flutter', ['emulators']);
  final emulatorLines = emulatorsResult.stdout.toString().split('\n');

  String? emulatorId;
  for (final line in emulatorLines) {
    if (line.toLowerCase().contains(platform)) {
      emulatorId = line.split('•').first.trim();
      break;
    }
  }

  if (emulatorId != null) {
    print('Launching emulator ($emulatorId) in background...');
    await Process.run('flutter', ['emulators', '--launch', emulatorId]);
  }

  print('Building generated code...');
  final buildProcess = await Process.start(
    'dart',
    ['run', 'build_runner', 'build', '--delete-conflicting-outputs'],
  );
  await stdout.addStream(buildProcess.stdout);
  await stderr.addStream(buildProcess.stderr);

  final buildExitCode = await buildProcess.exitCode;
  if (buildExitCode != 0) {
    print('Build failed');
    exit(buildExitCode);
  }

  print('Detecting connected $platform device...');
  String? deviceId;
  var retries = 5;
  while (retries > 0 && deviceId == null) {
    final devicesResult = await Process.run('flutter', ['devices']);
    final deviceLines = devicesResult.stdout.toString().split('\n');
    for (final line in deviceLines) {
      if (line.toLowerCase().contains(platform) &&
          line.toLowerCase().contains('mobile')) {
        final parts = line.split('•');
        if (parts.length > 1) {
          deviceId = parts[1].trim();
          break;
        }
      }
    }
    if (deviceId == null) {
      print('Waiting for device to register...');
      await Future<void>.delayed(const Duration(seconds: 2));
      retries--;
    }
  }

  if (deviceId == null) {
    print('No connected $platform device found. Launching shorthand...');
    deviceId = platform;
  }

  print('Running app on device: $deviceId');
  final runProcess = await Process.start('flutter', ['run', '-d', deviceId]);

  await stdout.addStream(runProcess.stdout);
  await stderr.addStream(runProcess.stderr);

  stdin.listen(runProcess.stdin.add);

  exit(await runProcess.exitCode);
}
