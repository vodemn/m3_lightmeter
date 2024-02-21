import 'package:integration_test/integration_test_driver_extended.dart';

import 'utils/grant_camera_permission.dart';

Future<void> main() async {
  await grantCameraPermission();
  await integrationDriver();
}
