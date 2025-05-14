import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'e2e_test.dart';
import 'metering_screen_layout_test.dart';
import 'purchases_test.dart';
import 'utils/platform_channel_mock.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    mockCameraFocalLength();
  });

  tearDownAll(() {
    mockCameraFocalLength();
  });

  testPurchases('Purchase & refund premium features');
  testToggleLayoutFeatures('Toggle metering screen layout features');
  testE2E('e2e');
}
