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
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/iso_picker/widget_picker_iso.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/widget_tester_extension.dart';

class _MockSharedPreferences extends Mock implements SharedPreferences {}

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
      IAPProviders(
        sharedPreferences: _MockSharedPreferences(),
        child: EquipmentProfiles(
          selected: _mockEquipmentProfiles[0],
          values: _mockEquipmentProfiles,
          child: Films(
            selected: const Film('Ilford HP5+', 400),
            values: const [Film.other(), Film('Ilford HP5+', 400)],
            filmsInUse: const [Film.other(), Film('Ilford HP5+', 400)],
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
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Pickers test', (tester) async {
    await pumpApplication(tester);

    await tester.takePhoto();

    expect(find.byType(IsoValuePicker), findsOneWidget);
    await binding.traceActionNamed(
      () async {
        await tester.tap(find.byType(IsoValuePicker));
        await tester.pumpAndSettle(Dimens.durationL);
        await tester.tapCancelButton();
      },
      "toggle_iso_picker",
    );
  });
}

extension on IntegrationTestWidgetsFlutterBinding {
  Future<void> traceActionNamed(Future<dynamic> Function() action, String timelineName) async {
    final nowString = DateTime.now().toIso8601String().replaceAll(':', '-');
    await traceAction(action, reportKey: "${timelineName}_$nowString");
  }
}

final _mockEquipmentProfiles = [
  const EquipmentProfile(
    id: '',
    name: '',
    apertureValues: ApertureValue.values,
    ndValues: NdValue.values,
    shutterSpeedValues: ShutterSpeedValue.values,
    isoValues: IsoValue.values,
  ),
  EquipmentProfile(
    id: '1',
    name: 'Praktica + Zenitar',
    apertureValues: ApertureValue.values.sublist(
      ApertureValue.values.indexOf(const ApertureValue(1.7, StopType.half)),
      ApertureValue.values.indexOf(const ApertureValue(16, StopType.full)) + 1,
    ),
    ndValues: NdValue.values.sublist(0, 3),
    shutterSpeedValues: ShutterSpeedValue.values.sublist(
      ShutterSpeedValue.values.indexOf(const ShutterSpeedValue(1000, true, StopType.full)),
      ShutterSpeedValue.values.indexOf(const ShutterSpeedValue(16, false, StopType.full)) + 1,
    ),
    isoValues: const [
      IsoValue(50, StopType.full),
      IsoValue(100, StopType.full),
      IsoValue(200, StopType.full),
      IsoValue(250, StopType.third),
      IsoValue(400, StopType.full),
      IsoValue(500, StopType.third),
      IsoValue(800, StopType.full),
      IsoValue(1600, StopType.full),
      IsoValue(3200, StopType.full),
    ],
  ),
  const EquipmentProfile(
    id: '2',
    name: 'Praktica + Jupiter',
    apertureValues: ApertureValue.values,
    ndValues: NdValue.values,
    shutterSpeedValues: ShutterSpeedValue.values,
    isoValues: IsoValue.values,
  ),
];
