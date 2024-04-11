import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../application_mock.dart';

class _SettingsScreenConfig {
  final IAPProductStatus iapProductStatus;

  _SettingsScreenConfig(this.iapProductStatus);

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write(iapProductStatus.toString().split('.')[1]);
    return buffer.toString();
  }
}

final _testScenarios = [IAPProductStatus.purchased, IAPProductStatus.purchasable].map(
  (iapProductStatus) => _SettingsScreenConfig(iapProductStatus),
);

void main() {
  Future<void> setTheme(WidgetTester tester, Key scenarioWidgetKey, ThemeType themeType) async {
    final flow = find.descendant(
      of: find.byKey(scenarioWidgetKey),
      matching: find.byType(SettingsFlow),
    );
    final BuildContext context = tester.element(flow);
    UserPreferencesProvider.of(context).setThemeType(themeType);
    await tester.pumpAndSettle();
  }

  setUpAll(() {
    SharedPreferences.setMockInitialValues({
      UserPreferencesService.evSourceTypeKey: EvSourceType.camera.index,
      UserPreferencesService.meteringScreenLayoutKey: json.encode(
        {
          MeteringScreenLayoutFeature.equipmentProfiles: true,
          MeteringScreenLayoutFeature.extremeExposurePairs: true,
          MeteringScreenLayoutFeature.filmPicker: true,
        }.toJson(),
      ),
    });
    PackageInfo.setMockInitialValues(
      appName: 'Lightmeter',
      packageName: 'com.vodemn.lightmeter',
      version: '0.18.0',
      buildNumber: '48',
      buildSignature: '',
    );
  });

  testGoldens(
    'SettingsScreen golden test',
    (tester) async {
      final builder = DeviceBuilder();
      for (final scenario in _testScenarios) {
        builder.addScenario(
          name: scenario.toString(),
          widget: _MockSettingsFlow(productStatus: scenario.iapProductStatus),
          onCreate: (scenarioWidgetKey) async {
            if (scenarioWidgetKey.toString().contains('Dark')) {
              await setTheme(tester, scenarioWidgetKey, ThemeType.dark);
            }
          },
        );
      }
      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(
        tester,
        'settings_screen',
      );
    },
  );
}

class _MockSettingsFlow extends StatelessWidget {
  final IAPProductStatus productStatus;

  const _MockSettingsFlow({required this.productStatus});

  @override
  Widget build(BuildContext context) {
    return GoldenTestApplicationMock(
      productStatus: productStatus,
      child: const SettingsFlow(),
    );
  }
}
