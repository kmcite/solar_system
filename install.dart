// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// final apkPath =
//     'D:\\03 Projects\\projects\\solar_system\\build\\app\\outputs\\flutter-apk\\app-release.apk';

// String? deviceName;
// bool isInstalling = false;
// int apkSizeBytes = 0;
// DateTime lastInstall = DateTime.fromMillisecondsSinceEpoch(0);
// final List<String> logLines = [];
// Timer? headerTimer;

// void log(String msg) {
//   final timestamp = DateTime.now().toIso8601String().substring(11, 19);
//   logLines.add('[$timestamp] $msg');
//   if (logLines.length > 3) logLines.removeAt(0);
// }

// Future<bool> isDeviceConnected() async {
//   try {
//     final result = await Process.run('adb', ['get-state']);
//     return result.stdout.toString().trim() == 'device';
//   } catch (e) {
//     return false;
//   }
// }

// Future<String?> getDeviceName() async {
//   try {
//     final result = await Process.run('adb', ['get-serialno']);
//     final output = result.stdout.toString().trim();
//     return output == 'unknown' ? null : output;
//   } catch (e) {
//     return null;
//   }
// }

// Future<void> connectDevice() async {
//   stdout.write('\nEnter device IP (e.g. 192.168.1.100): ');
//   final ip = stdin.readLineSync()?.trim();
//   if (ip == null || ip.isEmpty) return;
//   stdout.write('Enter port (default 5555): ');
//   var port = stdin.readLineSync()?.trim();
//   port = port?.isEmpty ?? true ? '5555' : port;

//   log('Connecting to $ip:$port...');
//   int attempts = 0;
//   while (!(await isDeviceConnected()) && attempts < 5) {
//     final result = await Process.run('adb', ['connect', '$ip:$port']);
//     if (result.exitCode != 0) {
//       log('Connection failed: ${result.stderr}');
//     }
//     await Future.delayed(Duration(seconds: 2));
//     attempts++;
//   }

//   if (await isDeviceConnected()) {
//     deviceName = '$ip:$port';
//     log('Connected to $deviceName');
//   } else {
//     log('Failed to connect after $attempts attempts');
//   }
// }

// Future<void> installApk() async {
//   if (isInstalling) return; // Prevent concurrent installs

//   isInstalling = true;
//   lastInstall = DateTime.now();
//   log('Installing APK...');

//   try {
//     // Use start() instead of run() to stream output
//     final process = await Process.start('adb', ['install', '-r', apkPath]);

//     // Show indeterminate progress while installing
//     final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
//       renderHeader(' [Installing...]');
//     });

//     final exitCode = await process.exitCode;
//     timer.cancel();

//     if (exitCode == 0) {
//       log('APK installation complete.');
//     } else {
//       final error = await process.stderr.transform(utf8.decoder).join();
//       log('Installation failed: $error');
//     }
//   } catch (e) {
//     log('Installation error: $e');
//   } finally {
//     isInstalling = false;
//     renderHeader();
//   }
// }

// void renderHeader([String extra = '']) {
//   final connected = isInstalling
//       ? 'Installing...'
//       : (deviceName != null ? 'Connected: $deviceName' : 'Disconnected');

//   final apkSizeMB = (apkSizeBytes / (1024 * 1024)).toStringAsFixed(2);
//   final status =
//       '| ${connected.padRight(30)} | APK: ${apkSizeMB.padLeft(6)} MB $extra';

//   final columns = stdout.hasTerminal ? stdout.terminalColumns : 80;
//   final padded = status.padRight(columns - 1);

//   stdout.write('\r$padded');
// }

// void watchApkFile(void Function() onChange) {
//   final file = File(apkPath);
//   if (!file.existsSync()) {
//     log('APK file not found: $apkPath');
//     return;
//   }

//   final dir = file.parent;
//   final name = file.uri.pathSegments.last;
//   DateTime? lastModified = file.lastModifiedSync();

//   dir.watch(events: FileSystemEvent.modify).listen((event) {
//     if (event.path.endsWith(name)) {
//       // Check if file was actually modified (size/time changed)
//       final currentModified = File(apkPath).lastModifiedSync();
//       if (lastModified == null || currentModified.isAfter(lastModified!)) {
//         lastModified = currentModified;
//         // Wait for file write to complete
//         Future.delayed(Duration(milliseconds: 1000), onChange);
//       }
//     }
//   });
// }

// void updateApkSize() {
//   final file = File(apkPath);
//   if (file.existsSync()) {
//     apkSizeBytes = file.lengthSync();
//   }
// }

// void printMenuAndLogs() {
//   stdout.writeln('\n');
//   for (final line in logLines) {
//     stdout.writeln(line);
//   }

//   stdout.writeln('\n--- Menu ---');
//   stdout.writeln('[1] Reconnect device');
//   stdout.writeln('[2] Re-install APK');
//   stdout.writeln('[3] Quit');
//   stdout.writeln('(Press 1, 2, or 3 + Enter)');
// }

// void handleInput() {
//   stdin.lineMode = true;
//   stdin.echoMode = true;
//   stdin.listen((event) async {
//     final input = utf8.decode(event).trim();
//     switch (input) {
//       case '1':
//         deviceName = null;
//         log('Reconnecting...');
//         await connectDevice();
//         printMenuAndLogs();
//         break;
//       case '2':
//         log('Manual re-install triggered.');
//         await installApk();
//         printMenuAndLogs();
//         break;
//       case '3':
//         log('Exiting...');
//         headerTimer?.cancel();
//         exit(0);
//     }
//   });
// }

// Future<void> main() async {
//   // Check if ADB is available
//   try {
//     await Process.run('adb', ['version']);
//   } catch (e) {
//     stdout.writeln(
//         'Error: ADB not found. Please install Android SDK Platform Tools.');
//     exit(1);
//   }

//   // Verify APK exists
//   if (!File(apkPath).existsSync()) {
//     stdout.writeln('Error: APK not found at $apkPath');
//     stdout.writeln('Please build the APK first with: flutter build apk');
//     exit(1);
//   }

//   stdout.writeln();
//   printMenuAndLogs();

//   if (!await isDeviceConnected()) {
//     log('No device connected.');
//     await connectDevice();
//   } else {
//     deviceName = await getDeviceName();
//     log('Device already connected: $deviceName');
//   }

//   updateApkSize();
//   await installApk();

//   watchApkFile(() async {
//     updateApkSize();
//     if (!await isDeviceConnected()) {
//       deviceName = null;
//       log('Device disconnected.');
//       return;
//     }
//     deviceName = await getDeviceName();
//     await installApk();
//     printMenuAndLogs();
//   });

//   handleInput();

//   headerTimer = Timer.periodic(Duration(seconds: 1), (_) async {
//     updateApkSize();
//     if (!await isDeviceConnected()) {
//       deviceName = null;
//     } else {
//       deviceName ??= await getDeviceName();
//     }
//     if (!isInstalling) {
//       renderHeader();
//     }
//   });
// }
