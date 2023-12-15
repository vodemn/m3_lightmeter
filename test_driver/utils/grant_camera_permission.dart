import 'dart:developer';
import 'dart:io';

Future<void> grantCameraPermission() async {
  try {
    final bool adbExists = Process.runSync('which', <String>['adb']).exitCode == 0;
    if (!adbExists) {
      log(r'This test needs ADB to exist on the $PATH. Skipping...');
      exit(0);
    }
    final deviceId = await Process.run('adb', ["-s", 'shell', 'devices']).then((value) {
      if (value.stdout is String) {
        return RegExp(r"(?:List of devices attached\n)([A-Z0-9]*)(?:\sdevice\n)")
            .firstMatch(value.stdout as String)!
            .group(1);
      }
    });
    if (deviceId == null) {
      log('This test needs at least one device connected');
      exit(0);
    }
    await Process.run('adb', [
      "-s",
      deviceId, // https://github.com/flutter/flutter/issues/86295#issuecomment-1192766368
      'shell',
      'pm',
      'grant',
      'com.vodemn.lightmeter.dev',
      'android.permission.CAMERA'
    ]);
  } catch (e) {
    log('Error occured: $e');
  }
}
