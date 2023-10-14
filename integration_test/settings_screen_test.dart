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
import 'package:lightmeter/res/theme.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/equipment_profile_picker/widget_picker_equipment_profiles.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/extreme_exposure_pairs_container/widget_container_extreme_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/film_picker/widget_picker_film.dart';
import 'package:lightmeter/screens/settings/components/metering/components/metering_screen_layout/components/meterins_screen_layout_features_dialog/widget_dialog_metering_screen_layout_features.dart';
import 'package:lightmeter/screens/settings/screen_settings.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';

import 'mocks/paid_features_mock.dart';
import 'utils/expectations.dart';
import 'utils/widget_tester_actions.dart';

class _MockUserPreferencesService extends Mock implements UserPreferencesService {}

class _MockCaffeineService extends Mock implements CaffeineService {}

class _MockHapticsService extends Mock implements HapticsService {}

class _MockPermissionsService extends Mock implements PermissionsService {}

class _MockLightSensorService extends Mock implements LightSensorService {}

class _MockVolumeEventsService extends Mock implements VolumeEventsService {}

const _defaultIsoValue = IsoValue(400, StopType.full);

//https://stackoverflow.com/a/67186625/13167574
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late _MockUserPreferencesService mockUserPreferencesService;
  late _MockCaffeineService mockCaffeineService;
  late _MockHapticsService mockHapticsService;
  late _MockPermissionsService mockPermissionsService;
  late _MockLightSensorService mockLightSensorService;
  late _MockVolumeEventsService mockVolumeEventsService;

  setUpAll(() {
    mockUserPreferencesService = _MockUserPreferencesService();
    when(() => mockUserPreferencesService.evSourceType).thenReturn(EvSourceType.sensor);
    when(() => mockUserPreferencesService.stopType).thenReturn(StopType.third);
    when(() => mockUserPreferencesService.locale).thenReturn(SupportedLocale.en);
    when(() => mockUserPreferencesService.caffeine).thenReturn(true);
    when(() => mockUserPreferencesService.volumeAction).thenReturn(VolumeAction.shutter);
    when(() => mockUserPreferencesService.cameraEvCalibration).thenReturn(0.0);
    when(() => mockUserPreferencesService.lightSensorEvCalibration).thenReturn(0.0);
    when(() => mockUserPreferencesService.iso).thenReturn(_defaultIsoValue);
    when(() => mockUserPreferencesService.ndFilter).thenReturn(NdValue.values.first);
    when(() => mockUserPreferencesService.haptics).thenReturn(true);
    when(() => mockUserPreferencesService.meteringScreenLayout).thenReturn({
      MeteringScreenLayoutFeature.equipmentProfiles: true,
      MeteringScreenLayoutFeature.extremeExposurePairs: true,
      MeteringScreenLayoutFeature.filmPicker: true,
      MeteringScreenLayoutFeature.histogram: false,
    });
    when(() => mockUserPreferencesService.themeType).thenReturn(ThemeType.light);
    when(() => mockUserPreferencesService.primaryColor).thenReturn(primaryColorsList[5]);
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
    when(() => mockPermissionsService.requestCameraPermission()).thenAnswer((_) async => PermissionStatus.granted);
    when(() => mockPermissionsService.checkCameraPermission()).thenAnswer((_) async => PermissionStatus.granted);

    mockLightSensorService = _MockLightSensorService();
    when(() => mockLightSensorService.hasSensor()).thenAnswer((_) async => true);
    when(() => mockLightSensorService.luxStream()).thenAnswer((_) => Stream.fromIterable([100]));

    mockVolumeEventsService = _MockVolumeEventsService();
    when(() => mockVolumeEventsService.setVolumeHandling(true)).thenAnswer((_) async => true);
    when(() => mockVolumeEventsService.setVolumeHandling(false)).thenAnswer((_) async => false);
    when(() => mockVolumeEventsService.volumeButtonsEventStream()).thenAnswer((_) => const Stream<int>.empty());

    when(() => mockHapticsService.quickVibration()).thenAnswer((_) async {});
    when(() => mockHapticsService.responseVibration()).thenAnswer((_) async {});
  });

  Future<void> pumpApplication(
    WidgetTester tester,
    IAPProductStatus purchaseStatus, {
    String selectedEquipmentProfileId = '',
    Film selectedFilm = const Film.other(),
  }) async {
    await tester.pumpWidget(
      MockIAPProviders(
        purchaseStatus: purchaseStatus,
        selectedEquipmentProfileId: selectedEquipmentProfileId,
        selectedFilm: selectedFilm,
        child: ServicesProvider(
          environment: const Environment.prod().copyWith(hasLightSensor: true),
          userPreferencesService: mockUserPreferencesService,
          caffeineService: mockCaffeineService,
          hapticsService: mockHapticsService,
          permissionsService: mockPermissionsService,
          lightSensorService: mockLightSensorService,
          volumeEventsService: mockVolumeEventsService,
          child: const UserPreferencesProvider(
            child: Application(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group(
    'Metering layout features',
    () {
      Future<void> toggleFeatureAndClose(WidgetTester tester, String feature) async {
        await tester.openSettings();
        expect(find.byType(SettingsScreen), findsOneWidget);
        await tester.tap(find.text(S.current.meteringScreenLayout));
        await tester.pumpAndSettle();
        expect(find.byType(MeteringScreenLayoutFeaturesDialog), findsOneWidget);
        await tester.tap(
          find.descendant(
            of: find.byType(SwitchListTile),
            matching: find.text(feature),
          ),
        );
        await tester.tapSaveButton();
        expect(find.byType(MeteringScreenLayoutFeaturesDialog), findsNothing);
        await tester.tap(find.byIcon(Icons.close));
        await tester.pumpAndSettle();
      }

      setUpAll(() {
        when(() => mockUserPreferencesService.evSourceType).thenReturn(EvSourceType.sensor);
        when(() => mockLightSensorService.luxStream()).thenAnswer((_) => Stream.fromIterable([100]));
        when(() => mockUserPreferencesService.meteringScreenLayout).thenReturn({
          MeteringScreenLayoutFeature.equipmentProfiles: true,
          MeteringScreenLayoutFeature.extremeExposurePairs: true,
          MeteringScreenLayoutFeature.filmPicker: true,
          MeteringScreenLayoutFeature.histogram: true,
        });
      });

      testWidgets(
        'Toggle equipmentProfiles & discard selected',
        (tester) async {
          await pumpApplication(
            tester,
            IAPProductStatus.purchased,
            selectedEquipmentProfileId: mockEquipmentProfiles[0].id,
          );
          await tester.toggleIncidentMetering();
          expectAnimatedPickerWith<EquipmentProfilePicker>(value: mockEquipmentProfiles[0].name);
          expectExposurePairsContainer('f/1.8 - 1/50', 'f/16 - 1.6"');
          expectMeasureButton(7.3);

          await toggleFeatureAndClose(tester, S.current.meteringScreenLayoutHintEquipmentProfiles);
          expect(find.byType(EquipmentProfilePicker), findsNothing);
          expectExposurePairsContainer('f/1.0 - 1/160', 'f/45 - 13"');
          expectMeasureButton(7.3);

          await toggleFeatureAndClose(tester, S.current.meteringScreenLayoutHintEquipmentProfiles);
          expectAnimatedPickerWith<EquipmentProfilePicker>(value: S.current.none);
          expectExposurePairsContainer('f/1.0 - 1/160', 'f/45 - 13"');
          expectMeasureButton(7.3);
        },
      );

      testWidgets(
        'Toggle extremeExposurePairs',
        (tester) async {
          await pumpApplication(tester, IAPProductStatus.purchased);
          await tester.toggleIncidentMetering();
          expectExposurePairsContainer('f/1.0 - 1/160', 'f/45 - 13"');
          expectMeasureButton(7.3);

          await toggleFeatureAndClose(tester, S.current.meteringScreenFeatureExtremeExposurePairs);
          expect(find.byType(ExtremeExposurePairsContainer), findsNothing);
          expectMeasureButton(7.3);

          await toggleFeatureAndClose(tester, S.current.meteringScreenFeatureExtremeExposurePairs);
          expectExposurePairsContainer('f/1.0 - 1/160', 'f/45 - 13"');
          expectMeasureButton(7.3);
        },
      );

      testWidgets(
        'Toggle film & discard selected',
        (tester) async {
          await pumpApplication(
            tester,
            IAPProductStatus.purchased,
            selectedFilm: mockFilms.first,
          );
          await tester.toggleIncidentMetering();
          expectAnimatedPickerWith<FilmPicker>(value: mockFilms.first.name);
          expectExposurePairsContainer('f/1.0 - 1/160', 'f/45 - 26"');
          expectMeasureButton(7.3);

          await toggleFeatureAndClose(tester, S.current.meteringScreenFeatureFilmPicker);
          expect(find.byType(FilmPicker), findsNothing);
          expectExposurePairsContainer('f/1.0 - 1/160', 'f/45 - 13"');
          expectMeasureButton(7.3);

          await toggleFeatureAndClose(tester, S.current.meteringScreenFeatureFilmPicker);
          expectAnimatedPickerWith<FilmPicker>(value: S.current.none);
          expectExposurePairsContainer('f/1.0 - 1/160', 'f/45 - 13"');
          expectMeasureButton(7.3);
        },
      );

      testWidgets(
        'Toggle histogram',
        (tester) async {
          await pumpApplication(tester, IAPProductStatus.purchased);
        },
        skip: true, // TODO(@vodemn)
      );
    },
  );
}

extension _WidgetTesterActions on WidgetTester {
  Future<void> openSettings() async {
    expect(find.byTooltip(S.current.tooltipOpenSettings), findsOneWidget);
    await tap(find.byTooltip(S.current.tooltipOpenSettings));
    await pumpAndSettle();
  }
}
