import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/iso_picker/widget_picker_iso.dart';
import 'package:lightmeter/screens/settings/components/metering/components/equipment_profiles/components/equipment_profile_screen/screen_equipment_profile.dart';
import 'package:lightmeter/screens/settings/screen_settings.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../integration_test/mocks/paid_features_mock.dart';
import '../integration_test/utils/widget_tester_actions.dart';
import 'models/screenshot_args.dart';

//https://stackoverflow.com/a/67186625/13167574

const _mockFilm = Film('Ilford HP5+', 400);
final Color _lightThemeColor = primaryColorsList[5];
final Color _darkThemeColor = primaryColorsList[3];
final ThemeData _themeLight = themeFrom(_lightThemeColor, Brightness.light);
final ThemeData _themeDark = themeFrom(_darkThemeColor, Brightness.dark);

/// Just a screenshot generator. No expectations here.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  void mockSharedPrefs(ThemeType theme, Color color) {
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({
      /// Metering values
      UserPreferencesService.evSourceTypeKey: EvSourceType.camera.index,
      UserPreferencesService.isoKey: 400,
      UserPreferencesService.ndFilterKey: 0,

      /// Metering settings
      UserPreferencesService.stopTypeKey: StopType.third.index,
      UserPreferencesService.cameraEvCalibrationKey: 0.0,
      UserPreferencesService.lightSensorEvCalibrationKey: 0.0,
      UserPreferencesService.meteringScreenLayoutKey: json.encode(
        {
          MeteringScreenLayoutFeature.equipmentProfiles: true,
          MeteringScreenLayoutFeature.extremeExposurePairs: true,
          MeteringScreenLayoutFeature.filmPicker: true,
        }.toJson(),
      ),

      /// General settings
      UserPreferencesService.caffeineKey: true,
      UserPreferencesService.hapticsKey: true,
      UserPreferencesService.volumeActionKey: VolumeAction.shutter.toString(),
      UserPreferencesService.localeKey: 'en',

      /// Theme settings
      UserPreferencesService.themeTypeKey: theme.index,
      UserPreferencesService.primaryColorKey: color.value,
      UserPreferencesService.dynamicColorKey: false,
    });
  }

  setUpAll(() async {
    if (Platform.isAndroid) await binding.convertFlutterSurfaceToImage();
  });

  /// Generates several screenshots with the light theme
  testWidgets('Generate light theme screenshots', (tester) async {
    mockSharedPrefs(ThemeType.light, _lightThemeColor);
    await tester.pumpApplication(
      availableFilms: [_mockFilm],
      filmsInUse: [_mockFilm],
      selectedFilm: _mockFilm,
    );

    await tester.takePhoto();
    await tester.takeScreenshot(binding, 'light-metering_reflected');

    if (Platform.isAndroid) {
      await tester.tap(find.byTooltip(S.current.tooltipUseLightSensor));
      await tester.pumpAndSettle();
      await tester.toggleIncidentMetering(7.3);
      await tester.takeScreenshot(binding, 'light-metering_incident');
    }

    await tester.openAnimatedPicker<IsoValuePicker>();
    await tester.takeScreenshot(binding, 'light-metering_iso_picker');

    await tester.tapCancelButton();
    await tester.tap(find.byTooltip(S.current.tooltipOpenSettings));
    await tester.pumpAndSettle();
    await tester.takeScreenshot(binding, 'light-settings');

    await tester.tapDescendantTextOf<SettingsScreen>(S.current.meteringScreenLayout);
    await tester.takeScreenshot(binding, 'light-settings_metering_screen_layout');

    await tester.tapCancelButton();
    await tester.tapDescendantTextOf<SettingsScreen>(S.current.equipmentProfiles);
    await tester.pumpAndSettle();
    await tester.tapDescendantTextOf<EquipmentProfilesScreen>(mockEquipmentProfiles.first.name);
    await tester.pumpAndSettle();
    await tester.takeScreenshot(binding, 'light-equipment_profiles');

    await tester.tap(find.byIcon(Icons.iso).first);
    await tester.pumpAndSettle();
    await tester.takeScreenshot(binding, 'light-equipment_profiles_iso_picker');
  });

  /// and the additionally the first one with the dark theme
  testWidgets(
    'Generate dark theme screenshots',
    (tester) async {
      mockSharedPrefs(ThemeType.dark, _darkThemeColor);
      await tester.pumpApplication(
        availableFilms: [_mockFilm],
        filmsInUse: [_mockFilm],
        selectedFilm: _mockFilm,
      );

      await tester.takePhoto();
      await tester.takeScreenshot(binding, 'dark-metering_reflected');

      if (Platform.isAndroid) {
        await tester.tap(find.byTooltip(S.current.tooltipUseLightSensor));
        await tester.pumpAndSettle();
        await tester.toggleIncidentMetering(7.3);
        await tester.takeScreenshot(binding, 'dark-metering_incident');
      }
    },
  );
}

final String _platformFolder = Platform.isAndroid ? 'android' : 'ios';

extension on WidgetTester {
  Future<void> takeScreenshot(IntegrationTestWidgetsFlutterBinding binding, String name) async {
    final bool isDark = name.contains('dark-');
    final Color backgroundColor = (isDark ? _themeDark : _themeLight).colorScheme.surface;
    await binding.takeScreenshot(
      ScreenshotArgs(
        name: name,
        deviceName: const String.fromEnvironment('deviceName').replaceAll(' ', '_').toLowerCase(),
        platformFolder: _platformFolder,
        backgroundColor: (
          r: backgroundColor.red,
          g: backgroundColor.green,
          b: backgroundColor.blue,
          a: backgroundColor.alpha,
        ),
        isDark: isDark,
      ).toString(),
    );
    await pumpAndSettle();
  }
}
