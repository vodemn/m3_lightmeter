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
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/components/measure_button/widget_button_measure.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/iso_picker/widget_picker_iso.dart';
import 'package:lightmeter/screens/settings/components/metering/components/equipment_profiles/components/equipment_profile_screen/components/equipment_profile_container/widget_container_equipment_profile.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/platform_channel_mock.dart';
import 'utils/widget_tester_actions.dart';

//https://stackoverflow.com/a/67186625/13167574
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final Color lightThemeColor = primaryColorsList[5];
  final Color darkThemeColor = primaryColorsList[3];

  void mockSharedPrefs(ThemeType theme, Color color) {
    setUp(() {
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
            MeteringScreenLayoutFeature.histogram: false,
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
    });
  }

  group(
    'Light theme',
    () {
      mockSharedPrefs(ThemeType.light, lightThemeColor);
      testWidgets(
        'Generate light screenshots',
        (tester) async {
          await tester.pumpApplication();

          await tester.takePhoto();
          await tester.takeScreenshot(binding, '${lightThemeColor.value}_metering_reflected');

          if (Platform.isAndroid) {
            await tester.tap(find.byTooltip(S.current.tooltipUseLightSensor));
            await tester.pumpAndSettle();
            await tester.tap(find.byType(MeteringMeasureButton));
            await sendMockIncidentEv(7.3);
            await tester.tap(find.byType(MeteringMeasureButton));
            await tester.takeScreenshot(binding, '${lightThemeColor.value}_metering_incident');
          }

          await tester.tap(find.byType(IsoValuePicker));
          await tester.pumpAndSettle(Dimens.durationL);
          await tester.takeScreenshot(binding, '${lightThemeColor.value}_metering_iso_picker');

          await tester.tapCancelButton();
          await tester.tap(find.byTooltip(S.current.tooltipOpenSettings));
          await tester.pumpAndSettle();
          await tester.takeScreenshot(binding, '${lightThemeColor.value}_settings');

          await tester.tapListTile(S.current.meteringScreenLayout);
          await tester.takeScreenshot(binding, '${lightThemeColor.value}_settings_metering_screen_layout');

          await tester.tapCancelButton();
          await tester.tapListTile(S.current.equipmentProfiles);
          await tester.tap(find.byType(EquipmentProfileContainer).first);
          await tester.pumpAndSettle();
          await tester.takeScreenshot(binding, '${lightThemeColor.value}-equipment_profiles');

          await tester.tap(find.byIcon(Icons.iso).first);
          await tester.pumpAndSettle();
          await tester.takeScreenshot(binding, '${lightThemeColor.value}_equipment_profiles_iso_picker');
        },
      );
    },
  );

  group(
    'Dark theme',
    () {
      mockSharedPrefs(ThemeType.dark, darkThemeColor);
      testWidgets(
        'Generate dark screenshots',
        (tester) async {
          await tester.pumpApplication();

          await tester.takePhoto();
          await tester.takeScreenshot(binding, '${darkThemeColor.value}_metering_reflected');

          if (Platform.isAndroid) {
            await tester.tap(find.byTooltip(S.current.tooltipUseLightSensor));
            await tester.pumpAndSettle();
            await tester.tap(find.byType(MeteringMeasureButton));
            await sendMockIncidentEv(7.3);
            await tester.tap(find.byType(MeteringMeasureButton));
            await tester.takeScreenshot(binding, '${darkThemeColor.value}_metering_incident');
          }
        },
      );
    },
  );
}

extension on WidgetTester {
  Future<void> takeScreenshot(IntegrationTestWidgetsFlutterBinding binding, String name) async {
    if (Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
      await pumpAndSettle();
    }
    await binding.takeScreenshot(name);
    await pumpAndSettle();
  }

  Future<void> takePhoto() async {
    await tap(find.byType(MeteringMeasureButton));
    await pump(const Duration(seconds: 2)); // wait for circular progress indicator
    await pump(const Duration(seconds: 1)); // wait for circular progress indicator
    await pumpAndSettle();
  }

  Future<void> tapListTile(String title) async {
    final listTile = find.byWidgetPredicate(
      (widget) => widget is ListTile && widget.title is Text && (widget.title as Text?)?.data == title,
    );
    expect(listTile, findsOneWidget);
    await tap(listTile);
    await pumpAndSettle();
  }
}
