import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lightmeter/application.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/components/measure_button/widget_button_measure.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/iso_picker/widget_picker_iso.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/dialog_picker/widget_picker_dialog.dart';
import 'package:lightmeter/screens/settings/components/metering/components/equipment_profiles/components/equipment_profile_screen/components/equipment_profile_container/widget_container_equipment_profile.dart';
import 'package:lightmeter/screens/settings/components/metering/components/equipment_profiles/components/equipment_profile_screen/screen_equipment_profile.dart';
import 'package:lightmeter/screens/settings/screen_settings.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';

import 'mocks/paid_features_mock.dart';

class _MockUserPreferencesService extends Mock implements UserPreferencesService {}

class _MockCaffeineService extends Mock implements CaffeineService {}

class _MockHapticsService extends Mock implements HapticsService {}

class _MockPermissionsService extends Mock implements PermissionsService {}

class _MockLightSensorService extends Mock implements LightSensorService {}

class _MockVolumeEventsService extends Mock implements VolumeEventsService {}

//https://stackoverflow.com/a/67186625/13167574
void main() {
  late _MockUserPreferencesService mockUserPreferencesService;
  late _MockCaffeineService mockCaffeineService;
  late _MockHapticsService mockHapticsService;
  late _MockPermissionsService mockPermissionsService;
  late _MockLightSensorService mockLightSensorService;
  late _MockVolumeEventsService mockVolumeEventsService;

  final binding = IntegrationTestWidgetsFlutterBinding();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    mockUserPreferencesService = _MockUserPreferencesService();
    when(() => mockUserPreferencesService.evSourceType).thenReturn(EvSourceType.camera);
    when(() => mockUserPreferencesService.stopType).thenReturn(StopType.third);
    when(() => mockUserPreferencesService.locale).thenReturn(SupportedLocale.en);
    when(() => mockUserPreferencesService.caffeine).thenReturn(true);
    when(() => mockUserPreferencesService.volumeAction).thenReturn(VolumeAction.shutter);
    when(() => mockUserPreferencesService.cameraEvCalibration).thenReturn(0.0);
    when(() => mockUserPreferencesService.lightSensorEvCalibration).thenReturn(0.0);
    when(() => mockUserPreferencesService.iso).thenReturn(const IsoValue(400, StopType.full));
    when(() => mockUserPreferencesService.ndFilter).thenReturn(NdValue.values.first);
    when(() => mockUserPreferencesService.haptics).thenReturn(true);
    when(() => mockUserPreferencesService.meteringScreenLayout).thenReturn({
      MeteringScreenLayoutFeature.equipmentProfiles: true,
      MeteringScreenLayoutFeature.extremeExposurePairs: true,
      MeteringScreenLayoutFeature.filmPicker: true,
      MeteringScreenLayoutFeature.histogram: false,
    });
    when(() => mockUserPreferencesService.themeType).thenReturn(ThemeType.light);
    when(() => mockUserPreferencesService.dynamicColor).thenReturn(false);

    mockCaffeineService = _MockCaffeineService();
    when(() => mockCaffeineService.isKeepScreenOn()).thenAnswer((_) async => false);
    when(() => mockCaffeineService.keepScreenOn(true)).thenAnswer((_) async => true);
    when(() => mockCaffeineService.keepScreenOn(false)).thenAnswer((_) async => false);

    mockHapticsService = _MockHapticsService();
    when(() => mockHapticsService.quickVibration()).thenAnswer((_) async {});
    when(() => mockHapticsService.responseVibration()).thenAnswer((_) async {});
    when(() => mockHapticsService.errorVibration()).thenAnswer((_) async {});

    mockPermissionsService = _MockPermissionsService();
    when(() => mockPermissionsService.requestCameraPermission())
        .thenAnswer((_) async => PermissionStatus.granted);
    when(() => mockPermissionsService.checkCameraPermission())
        .thenAnswer((_) async => PermissionStatus.granted);

    mockLightSensorService = _MockLightSensorService();
    when(() => mockLightSensorService.hasSensor()).thenAnswer((_) async => true);
    when(() => mockLightSensorService.luxStream()).thenAnswer((_) => Stream.fromIterable([100]));

    mockVolumeEventsService = _MockVolumeEventsService();
    when(() => mockVolumeEventsService.setVolumeHandling(true)).thenAnswer((_) async => true);
    when(() => mockVolumeEventsService.setVolumeHandling(false)).thenAnswer((_) async => false);
    when(() => mockVolumeEventsService.volumeButtonsEventStream())
        .thenAnswer((_) => const Stream<int>.empty());

    when(() => mockHapticsService.quickVibration()).thenAnswer((_) async {});
    when(() => mockHapticsService.responseVibration()).thenAnswer((_) async {});
  });

  Future<void> pumpApplication(WidgetTester tester) async {
    await tester.pumpWidget(
      MockIAPProviders.purchased(
        selectedFilm: mockFilms.first,
        child: ServicesProvider(
          environment: const Environment.prod().copyWith(hasLightSensor: true),
          userPreferencesService: mockUserPreferencesService,
          caffeineService: mockCaffeineService,
          hapticsService: mockHapticsService,
          permissionsService: mockPermissionsService,
          lightSensorService: mockLightSensorService,
          volumeEventsService: mockVolumeEventsService,
          child: const UserPreferencesProvider(child: Application()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Generates several screenshots with the light theme
  /// and the additionally the first one with the dark theme
  void generateScreenshots(Color color) {
    testWidgets('${color.value}_light', (tester) async {
      when(() => mockUserPreferencesService.themeType).thenReturn(ThemeType.light);
      when(() => mockUserPreferencesService.primaryColor).thenReturn(color);
      await pumpApplication(tester);

      await tester.takePhoto();
      await tester.takeScreenshot(binding, '${color.value}_metering_reflected');

      await tester.tap(find.byTooltip(S.current.tooltipUseLightSensor));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(MeteringMeasureButton));
      await tester.tap(find.byType(MeteringMeasureButton));
      await tester.takeScreenshot(binding, '${color.value}_metering_incident');

      expect(find.byType(IsoValuePicker), findsOneWidget);
      await tester.tap(find.byType(IsoValuePicker));
      await tester.pumpAndSettle(Dimens.durationL);
      expect(find.byType(DialogPicker<IsoValue>), findsOneWidget);
      await tester.takeScreenshot(binding, '${color.value}_metering_iso_picker');

      await tester.tapCancelButton();
      expect(find.byType(DialogPicker<IsoValue>), findsNothing);
      expect(find.byTooltip(S.current.tooltipOpenSettings), findsOneWidget);
      await tester.tap(find.byTooltip(S.current.tooltipOpenSettings));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);
      await tester.takeScreenshot(binding, '${color.value}_settings');

      await tester.tapListTile(S.current.meteringScreenLayout);
      await tester.takeScreenshot(binding, '${color.value}_settings_metering_screen_layout');

      await tester.tapCancelButton();
      await tester.tapListTile(S.current.equipmentProfiles);
      expect(find.byType(EquipmentProfilesScreen), findsOneWidget);
      await tester.tap(find.byType(EquipmentProfileContainer).first);
      await tester.pumpAndSettle();
      await tester.takeScreenshot(binding, '${color.value}-equipment_profiles');

      await tester.tap(find.byIcon(Icons.iso).first);
      await tester.pumpAndSettle();
      await tester.takeScreenshot(binding, '${color.value}_equipment_profiles_iso_picker');
    });

    testWidgets(
      '${color.value}_dark',
      (tester) async {
        when(() => mockUserPreferencesService.themeType).thenReturn(ThemeType.dark);
        when(() => mockUserPreferencesService.primaryColor).thenReturn(color);
        await pumpApplication(tester);

        await tester.takePhoto();
        await tester.takeScreenshot(binding, '${color.value}_metering_reflected_dark');

        await tester.tap(find.byTooltip(S.current.tooltipUseLightSensor));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(MeteringMeasureButton));
        await tester.tap(find.byType(MeteringMeasureButton));
        await tester.takeScreenshot(binding, '${color.value}_metering_incident_dark');
      },
    );
  }

  generateScreenshots(primaryColorsList[5]);
  generateScreenshots(primaryColorsList[3]);
  generateScreenshots(primaryColorsList[9]);
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

  Future<void> tapCancelButton() async {
    final cancelButton = find.byWidgetPredicate(
      (widget) =>
          widget is TextButton &&
          widget.child is Text &&
          (widget.child as Text?)?.data == S.current.cancel,
    );
    expect(cancelButton, findsOneWidget);
    await tap(cancelButton);
    await pumpAndSettle();
  }

  Future<void> tapListTile(String title) async {
    final listTile = find.byWidgetPredicate(
      (widget) =>
          widget is ListTile && widget.title is Text && (widget.title as Text?)?.data == title,
    );
    expect(listTile, findsOneWidget);
    await tap(listTile);
    await pumpAndSettle();
  }
}
