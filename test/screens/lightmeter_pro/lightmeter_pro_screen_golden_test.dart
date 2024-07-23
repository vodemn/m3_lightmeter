import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/screens/lightmeter_pro/screen_lightmeter_pro.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../application_mock.dart';
import '../../utils/golden_test_set_theme.dart';

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  testGoldens(
    'LightmeterProScreen golden test',
    (tester) async {
      final builder = DeviceBuilder();
      builder.addScenario(
        name: 'Get Pro',
        widget: const _MockLightmeterProFlow(),
        onCreate: (scenarioWidgetKey) async {
          if (scenarioWidgetKey.toString().contains('Dark')) {
            await setTheme<LightmeterProScreen>(tester, scenarioWidgetKey, ThemeType.dark);
          }
        },
      );
      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(
        tester,
        'lightmeter_pro_screen',
      );
    },
  );
}

class _MockLightmeterProFlow extends StatelessWidget {
  const _MockLightmeterProFlow();

  @override
  Widget build(BuildContext context) {
    return GoldenTestApplicationMock(
      productStatus: IAPProductStatus.purchasable,
      child: LightmeterProScreen(),
    );
  }
}
