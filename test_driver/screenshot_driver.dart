import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

import 'utils/grant_camera_permission.dart';

Future<void> main() async {
  await grantCameraPermission();
  await integrationDriver(
    onScreenshot: (name, bytes, [args]) async {
      final File image = await File('screenshots/TEST_$name.png').create(recursive: true);
      image.writeAsBytesSync(bytes);
      return true;
    },
  );
}
