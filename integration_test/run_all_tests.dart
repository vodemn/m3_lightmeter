import 'package:integration_test/integration_test.dart';

import 'metering_screen_layout_test.dart';
import 'purchases_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testPurchases('Purchase & refund premium features');
  testToggleLayoutFeatures('Toggle metering screen layout features');
}
