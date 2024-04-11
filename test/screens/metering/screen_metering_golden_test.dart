import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:light_sensor/light_sensor.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/components/measure_button/widget_button_measure.dart';
import 'package:lightmeter/screens/metering/flow_metering.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../integration_test/utils/platform_channel_mock.dart';
import '../../application_mock.dart';

class _MeteringScreenConfig {
  final IAPProductStatus iapProductStatus;
  final EvSourceType evSourceType;

  _MeteringScreenConfig(
    this.iapProductStatus,
    this.evSourceType,
  );

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write(iapProductStatus.toString().split('.')[1]);
    buffer.write(' - ');
    buffer.write(evSourceType.toString().split('.')[1]);
    return buffer.toString();
  }
}

final _testScenarios = [IAPProductStatus.purchased, IAPProductStatus.purchasable].expand(
  (iapProductStatus) => EvSourceType.values.map(
    (evSourceType) => _MeteringScreenConfig(iapProductStatus, evSourceType),
  ),
);

void main() {
  Future<void> setEvSource(WidgetTester tester, Key scenarioWidgetKey, EvSourceType evSourceType) async {
    final flow = find.descendant(
      of: find.byKey(scenarioWidgetKey),
      matching: find.byType(MeteringFlow),
    );
    final BuildContext context = tester.element(flow);
    if (UserPreferencesProvider.evSourceTypeOf(context) != evSourceType) {
      UserPreferencesProvider.of(context).toggleEvSourceType();
    }
    await tester.pumpAndSettle();
  }

  Future<void> setTheme(WidgetTester tester, Key scenarioWidgetKey, ThemeType themeType) async {
    final flow = find.descendant(
      of: find.byKey(scenarioWidgetKey),
      matching: find.byType(MeteringFlow),
    );
    final BuildContext context = tester.element(flow);
    UserPreferencesProvider.of(context).setThemeType(themeType);
    await tester.pumpAndSettle();
  }

  Future<void> takePhoto(WidgetTester tester, Key scenarioWidgetKey) async {
    final button = find.descendant(
      of: find.byKey(scenarioWidgetKey),
      matching: find.byType(MeteringMeasureButton),
    );
    await tester.tap(button);
    await tester.pump(const Duration(seconds: 2)); // wait for circular progress indicator
    await tester.pump(const Duration(seconds: 1)); // wait for circular progress indicator
    await tester.pumpAndSettle();
  }

  Future<void> toggleIncidentMetering(WidgetTester tester, Key scenarioWidgetKey, double ev) async {
    final button = find.descendant(
      of: find.byKey(scenarioWidgetKey),
      matching: find.byType(MeteringMeasureButton),
    );
    await tester.tap(button);
    await sendMockIncidentEv(ev);
    await tester.tap(button);
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
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      LightSensor.methodChannel,
      (methodCall) async {
        switch (methodCall.method) {
          case "sensor":
            return true;
          default:
            return null;
        }
      },
    );
    setupLightSensorStreamHandler();
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      LightSensor.methodChannel,
      null,
    );
  });

  testGoldens(
    'MeteringScreen golden test',
    (tester) async {
      final builder = DeviceBuilder();
      for (final scenario in _testScenarios) {
        builder.addScenario(
          name: scenario.toString(),
          widget: _MockMeteringFlow(productStatus: scenario.iapProductStatus),
          onCreate: (scenarioWidgetKey) async {
            await setEvSource(tester, scenarioWidgetKey, scenario.evSourceType);
            if (scenarioWidgetKey.toString().contains('Dark')) {
              await setTheme(tester, scenarioWidgetKey, ThemeType.dark);
            }
            if (scenario.evSourceType == EvSourceType.camera) {
              await takePhoto(tester, scenarioWidgetKey);
            } else {
              await toggleIncidentMetering(tester, scenarioWidgetKey, 7.3);
            }
          },
        );
      }
      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(
        tester,
        'metering_screen',
      );
    },
  );
}

class _MockMeteringFlow extends StatelessWidget {
  final IAPProductStatus productStatus;

  const _MockMeteringFlow({required this.productStatus});

  @override
  Widget build(BuildContext context) {
    return GoldenTestApplicationMock(
      productStatus: productStatus,
      child: const MeteringFlow(),
    );
  }
}
