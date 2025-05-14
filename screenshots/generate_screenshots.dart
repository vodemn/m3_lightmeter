// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lightmeter/data/models/camera_feature.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:lightmeter/screens/metering/components/shared/exposure_pairs_list/widget_list_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/iso_picker/widget_picker_iso.dart';
import 'package:lightmeter/screens/metering/screen_metering.dart';
import 'package:lightmeter/screens/settings/screen_settings.dart';
import 'package:lightmeter/screens/shared/animated_circular_button/widget_button_circular_animated.dart';
import 'package:lightmeter/screens/timer/screen_timer.dart';
import 'package:lightmeter/utils/color_to_int.dart';
import 'package:lightmeter/utils/platform_utils.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../integration_test/mocks/paid_features_mock.dart';
import '../integration_test/utils/platform_channel_mock.dart';
import '../integration_test/utils/widget_tester_actions.dart';
import 'models/screenshot_args.dart';

//https://stackoverflow.com/a/67186625/13167574

const _mockFilm = FilmExponential(id: '1', name: 'Ilford HP5+', iso: 400, exponent: 1.34);
final Color _lightThemeColor = primaryColorsList[5];
final Color _darkThemeColor = primaryColorsList[3];
final ThemeData _themeLight = themeFrom(_lightThemeColor, Brightness.light);
final ThemeData _themeDark = themeFrom(_darkThemeColor, Brightness.dark);

/// Just a screenshot generator. No expectations here.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> mockSharedPrefs({
    int iso = 400,
    int nd = 0,
    double calibration = 0.0,
    required ThemeType theme,
    required Color color,
  }) async {
    SharedPreferences.setMockInitialValues({
      /// Metering values
      UserPreferencesService.evSourceTypeKey: EvSourceType.camera.index,
      UserPreferencesService.isoKey: iso,
      UserPreferencesService.ndFilterKey: nd,

      /// Metering settings
      UserPreferencesService.stopTypeKey: StopType.third.index,
      UserPreferencesService.cameraEvCalibrationKey: calibration,
      UserPreferencesService.lightSensorEvCalibrationKey: calibration,
      UserPreferencesService.meteringScreenLayoutKey: json.encode(
        {
          MeteringScreenLayoutFeature.equipmentProfiles: true,
          MeteringScreenLayoutFeature.extremeExposurePairs: true,
          MeteringScreenLayoutFeature.filmPicker: true,
        }.toJson(),
      ),

      UserPreferencesService.cameraFeaturesKey: json.encode(
        {
          CameraFeature.spotMetering: false,
          CameraFeature.histogram: false,
          CameraFeature.showFocalLength: true,
        }.toJson(),
      ),

      /// General settings
      UserPreferencesService.autostartTimerKey: false,
      UserPreferencesService.caffeineKey: true,
      UserPreferencesService.hapticsKey: true,
      UserPreferencesService.volumeActionKey: VolumeAction.shutter.toString(),
      UserPreferencesService.localeKey: 'en',

      /// Theme settings
      UserPreferencesService.themeTypeKey: theme.index,
      UserPreferencesService.primaryColorKey: color.toInt(),
      UserPreferencesService.dynamicColorKey: false,

      UserPreferencesService.seenChangelogVersionKey: await const PlatformUtils().version,
    });
  }

  setUpAll(() async {
    if (Platform.isAndroid) await binding.convertFlutterSurfaceToImage();
    mockCameraFocalLength();
  });

  tearDownAll(() {
    resetCameraFocalLength();
  });

  /// Generates several screenshots with the light theme
  testWidgets('Generate light theme screenshots', (tester) async {
    await mockSharedPrefs(theme: ThemeType.light, color: _lightThemeColor);
    await tester.pumpApplication(
      predefinedFilms: [_mockFilm].toTogglableMap(),
      customFilms: {},
      selectedFilmId: _mockFilm.id,
    );

    await tester.takePhoto();
    await tester.takeScreenshotLight(binding, 'metering-reflected');

    if (Platform.isAndroid) {
      await tester.tap(find.byTooltip(S.current.tooltipUseLightSensor));
      await tester.pumpAndSettle();
      await tester.toggleIncidentMetering(7.3);
      await tester.takeScreenshotLight(binding, 'metering-incident');
    }

    await tester.openAnimatedPicker<IsoValuePicker>();
    await tester.takeScreenshotLight(binding, 'metering-iso-picker');

    await tester.tapCancelButton();
    await tester.tap(find.byTooltip(S.current.tooltipOpenSettings));
    await tester.pumpAndSettle();
    await tester.takeScreenshotLight(binding, 'settings');

    await tester.tapDescendantTextOf<SettingsScreen>(S.current.equipmentProfiles);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit_outlined).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(S.current.isoValues)); // open and close a dialog to hide keyboard
    await tester.pumpAndSettle();
    await tester.tapCancelButton();
    await tester.takeScreenshotLight(binding, 'equipment-profiles');
  });

  /// and the additionally the first one with the dark theme
  testWidgets(
    'Generate dark theme screenshots',
    (tester) async {
      await mockSharedPrefs(theme: ThemeType.dark, color: _darkThemeColor);
      await tester.pumpApplication(
        predefinedFilms: [_mockFilm].toTogglableMap(),
        customFilms: {},
        selectedFilmId: _mockFilm.id,
      );

      await tester.takePhoto();
      await tester.takeScreenshotDark(binding, 'metering-reflected');
    },
  );

  testWidgets(
    'Generate timer screenshot',
    (tester) async {
      const timerExposurePair = ExposurePair(
        ApertureValue(16, StopType.full),
        ShutterSpeedValue(8, false, StopType.full),
      );
      await mockSharedPrefs(
        iso: 100,
        nd: 8,
        calibration: -0.3,
        theme: ThemeType.light,
        color: _lightThemeColor,
      );
      await tester.pumpApplication(
        predefinedFilms: [_mockFilm].toTogglableMap(),
        customFilms: {},
        selectedFilmId: _mockFilm.id,
      );

      await tester.takePhoto();
      await tester.scrollToExposurePair(
        ev: 5,
        exposurePair: timerExposurePair,
      );
      await tester.tap(find.text(_mockFilm.reciprocityFailure(timerExposurePair.shutterSpeed).toString()));
      await tester.pumpAndSettle();
      await tester.mockTimerResumedState(timerExposurePair.shutterSpeed);
      await tester.takeScreenshotLight(binding, 'timer');
    },
  );
}

final String _platformFolder = Platform.isAndroid ? 'android' : 'ios';

extension on WidgetTester {
  Future<void> takeScreenshotLight(IntegrationTestWidgetsFlutterBinding binding, String name) =>
      _takeScreenshot(binding, name, _themeLight);
  Future<void> takeScreenshotDark(IntegrationTestWidgetsFlutterBinding binding, String name) =>
      _takeScreenshot(binding, name, _themeDark);

  Future<void> _takeScreenshot(IntegrationTestWidgetsFlutterBinding binding, String name, ThemeData theme) async {
    final Color backgroundColor = theme.colorScheme.surface;
    await binding.takeScreenshot(
      ScreenshotArgs(
        name: name,
        deviceName: const String.fromEnvironment('deviceName'),
        platformFolder: _platformFolder,
        backgroundColor: backgroundColor.toInt().toRadixString(16),
        isDark: theme.brightness == Brightness.dark,
      ).toString(),
    );
    await pumpAndSettle();
  }
}

extension on WidgetTester {
  Future<void> scrollToExposurePair({
    double ev = mockPhotoEv100,
    EquipmentProfile equipmentProfile = defaultEquipmentProfile,
    required ExposurePair exposurePair,
  }) async {
    final exposurePairs = MeteringContainerBuidler.buildExposureValues(
      ev,
      StopType.third,
      equipmentProfile,
    );

    await scrollUntilVisible(
      find.byWidgetPredicate((widget) => widget is Row && widget.key == ValueKey(exposurePairs.indexOf(exposurePair))),
      56,
      scrollable: find.descendant(of: find.byType(ExposurePairsList), matching: find.byType(Scrollable)),
    );
  }

  Future<void> mockTimerResumedState(ShutterSpeedValue shutterSpeedValue) async {
    await tap(find.byType(AnimatedCircluarButton));
    await pump(Dimens.durationS);

    late final skipTimerDuration =
        Duration(milliseconds: (shutterSpeedValue.value * 0.35 * Duration.millisecondsPerSecond).toInt());
    await pump(skipTimerDuration);

    final TimerScreenState state = this.state(find.byType(TimerScreen));
    state.startStopIconController.stop();
    state.timelineController.stop();
    await pump();
  }
}
