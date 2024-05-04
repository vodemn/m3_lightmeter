import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/shared/animated_circular_button/widget_button_circular_animated.dart';
import 'package:lightmeter/screens/timer/flow_timer.dart';
import 'package:lightmeter/screens/timer/screen_timer.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../application_mock.dart';

class _TimerScreenConfig {
  final ShutterSpeedValue shutterSpeedValue;
  final bool isStopped;

  _TimerScreenConfig({
    required this.shutterSpeedValue,
    required this.isStopped,
  });

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write(shutterSpeedValue.toString());
    buffer.write(' - ');
    buffer.write(isStopped ? 'stopped' : 'resumed');
    return buffer.toString();
  }
}

final _testScenarios = [
  const ShutterSpeedValue(
    74,
    false,
    StopType.full,
  ),
  const ShutterSpeedValue(
    3642,
    false,
    StopType.full,
  ),
].expand(
  (shutterSpeedValue) => [
    _TimerScreenConfig(shutterSpeedValue: shutterSpeedValue, isStopped: true),
    _TimerScreenConfig(shutterSpeedValue: shutterSpeedValue, isStopped: false),
  ],
);

void main() {
  Future<void> setTheme(WidgetTester tester, Key scenarioWidgetKey, ThemeType themeType) async {
    final flow = find.descendant(
      of: find.byKey(scenarioWidgetKey),
      matching: find.byType(TimerFlow),
    );
    final BuildContext context = tester.element(flow);
    UserPreferencesProvider.of(context).setThemeType(themeType);
    await tester.pumpAndSettle();
  }

  Future<void> toggleTimer(WidgetTester tester, Key scenarioWidgetKey) async {
    final button = find.descendant(
      of: find.byKey(scenarioWidgetKey),
      matching: find.byType(AnimatedCircluarButton),
    );
    await tester.tap(button);
    await tester.pump(Dimens.durationS);
  }

  Future<void> mockResumedState(WidgetTester tester, Key scenarioWidgetKey) async {
    final screen = find.descendant(
      of: find.byKey(scenarioWidgetKey),
      matching: find.byType(TimerScreen),
    );
    final TimerScreenState state = tester.state(screen);
    state.startStopIconController.stop();
    state.timelineController.stop();
    await tester.pump();
  }

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  testGoldens(
    'TimerScreen golden test',
    (tester) async {
      final builder = DeviceBuilder();
      for (final scenario in _testScenarios) {
        builder.addScenario(
          name: scenario.toString(),
          widget: _MockTimerFlow(scenario.shutterSpeedValue),
          onCreate: (scenarioWidgetKey) async {
            if (scenarioWidgetKey.toString().contains('Dark')) {
              await setTheme(tester, scenarioWidgetKey, ThemeType.dark);
            }
            if (!scenario.isStopped) {
              await toggleTimer(tester, scenarioWidgetKey);
              late final skipTimerDuration = Duration(
                milliseconds: (scenario.shutterSpeedValue.value * 0.35 * Duration.millisecondsPerSecond).toInt(),
              );
              await tester.pump(skipTimerDuration);
              await mockResumedState(tester, scenarioWidgetKey);
            }
          },
        );
      }
      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(
        tester,
        'timer_screen',
      );
    },
  );
}

class _MockTimerFlow extends StatelessWidget {
  final ShutterSpeedValue shutterSpeedValue;

  const _MockTimerFlow(this.shutterSpeedValue);

  @override
  Widget build(BuildContext context) {
    return GoldenTestApplicationMock(
      child: TimerFlow(
        args: TimerFlowArgs(
          exposurePair: ExposurePair(
            ApertureValue.values.first,
            shutterSpeedValue,
          ),
          isoValue: const IsoValue(100, StopType.full),
          ndValue: const NdValue(0),
        ),
      ),
    );
  }
}
