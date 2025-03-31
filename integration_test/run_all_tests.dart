import 'package:integration_test/integration_test.dart';

import 'e2e_test.dart';
import 'metering_screen_layout_test.dart';
import 'purchases_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testPurchases('Purchase & refund premium features');
  testToggleLayoutFeatures('Toggle metering screen layout features');
  testE2E(
    'e2e',
    screenshotCallback: () async {
      await IntegrationTestWidgetsFlutterBinding.instance.takeScreenshot('screenshot_e2e');
    },
  );
}
