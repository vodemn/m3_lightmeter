import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/screens/settings/flow_settings.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../application_mock.dart';
import '../../utils/golden_test_set_theme.dart';

class _SettingsScreenConfig {
  final bool isPro;

  _SettingsScreenConfig(this.isPro);

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write(isPro ? 'purchased' : 'purchasable');
    return buffer.toString();
  }
}

final _testScenarios = [true, false].map((isPro) => _SettingsScreenConfig(isPro));

void main() {
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
          widget: _MockSettingsFlow(isPro: scenario.isPro),
          onCreate: (scenarioWidgetKey) async {
            if (scenarioWidgetKey.toString().contains('Dark')) {
              await setTheme<SettingsFlow>(tester, scenarioWidgetKey, ThemeType.dark);
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
  final bool isPro;

  const _MockSettingsFlow({required this.isPro});

  @override
  Widget build(BuildContext context) {
    return GoldenTestApplicationMock(
      isPro: isPro,
      child: const SettingsFlow(),
    );
  }
}
