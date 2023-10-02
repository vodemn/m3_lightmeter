import 'dart:developer';
import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

import 'utils/android_camera_permission.dart';

Future<void> main() async {
  try {
    await grandCameraPermission();
    await integrationDriver(
      onScreenshot: (name, bytes, [args]) async {
        final File image = await File('screenshots/$name.png').create(recursive: true);
        image.writeAsBytesSync(bytes);
        return true;
      },
    );
  } catch (e) {
    log('Error occured: $e');
  }
}
