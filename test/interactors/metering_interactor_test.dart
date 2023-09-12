import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';

class _MockUserPreferencesService extends Mock implements UserPreferencesService {}

class _MockCaffeineService extends Mock implements CaffeineService {}

class _MockHapticsService extends Mock implements HapticsService {}

class _MockPermissionsService extends Mock implements PermissionsService {}

class _MockLightSensorService extends Mock implements LightSensorService {}

class _MockVolumeEventsService extends Mock implements VolumeEventsService {}

void main() {
  late _MockUserPreferencesService mockUserPreferencesService;
  late _MockCaffeineService mockCaffeineService;
  late _MockHapticsService mockHapticsService;
  late _MockPermissionsService mockPermissionsService;
  late _MockLightSensorService mockLightSensorService;
  late _MockVolumeEventsService mockVolumeEventsService;

  late MeteringInteractor interactor;

  setUp(() {
    mockUserPreferencesService = _MockUserPreferencesService();
    mockCaffeineService = _MockCaffeineService();
    mockHapticsService = _MockHapticsService();
    mockPermissionsService = _MockPermissionsService();
    mockLightSensorService = _MockLightSensorService();
    mockVolumeEventsService = _MockVolumeEventsService();

    interactor = MeteringInteractor(
      mockUserPreferencesService,
      mockCaffeineService,
      mockHapticsService,
      mockPermissionsService,
      mockLightSensorService,
      mockVolumeEventsService,
    );
  });

  group(
    'Initalization',
    () {
      test('caffeine - true', () async {
        when(() => mockUserPreferencesService.caffeine).thenReturn(true);
        when(() => mockCaffeineService.keepScreenOn(true)).thenAnswer((_) async => true);
        when(() => mockUserPreferencesService.volumeAction).thenReturn(VolumeAction.shutter);
        when(() => mockVolumeEventsService.setVolumeHandling(true)).thenAnswer((_) async => true);
        interactor.initialize();
        verify(() => mockUserPreferencesService.caffeine).called(1);
        verify(() => mockCaffeineService.keepScreenOn(true)).called(1);
        verify(() => mockVolumeEventsService.setVolumeHandling(true)).called(1);
      });

      test('caffeine - false', () async {
        when(() => mockUserPreferencesService.caffeine).thenReturn(false);
        when(() => mockCaffeineService.keepScreenOn(false)).thenAnswer((_) async => false);
        when(() => mockUserPreferencesService.volumeAction).thenReturn(VolumeAction.shutter);
        when(() => mockVolumeEventsService.setVolumeHandling(true)).thenAnswer((_) async => true);
        interactor.initialize();
        verify(() => mockUserPreferencesService.caffeine).called(1);
        verifyNever(() => mockCaffeineService.keepScreenOn(false));
        verify(() => mockVolumeEventsService.setVolumeHandling(true)).called(1);
      });
    },
  );

  group(
    'Calibration',
    () {
      test('cameraEvCalibration', () async {
        when(() => mockUserPreferencesService.cameraEvCalibration).thenReturn(0.0);
        expect(interactor.cameraEvCalibration, 0.0);
        verify(() => mockUserPreferencesService.cameraEvCalibration).called(1);
      });

      test('lightSensorEvCalibration', () async {
        when(() => mockUserPreferencesService.lightSensorEvCalibration).thenReturn(0.0);
        expect(interactor.lightSensorEvCalibration, 0.0);
        verify(() => mockUserPreferencesService.lightSensorEvCalibration).called(1);
      });
    },
  );

  group(
    'Equipment',
    () {
      test('iso - get', () async {
        when(() => mockUserPreferencesService.iso).thenReturn(IsoValue.values.first);
        expect(interactor.iso, IsoValue.values.first);
        verify(() => mockUserPreferencesService.iso).called(1);
      });

      test('iso - set', () async {
        when(() => mockUserPreferencesService.iso = IsoValue.values.first)
            .thenReturn(IsoValue.values.first);
        interactor.iso = IsoValue.values.first;
        verify(() => mockUserPreferencesService.iso = IsoValue.values.first).called(1);
      });

      test('ndFilter - get', () async {
        when(() => mockUserPreferencesService.ndFilter).thenReturn(NdValue.values.first);
        expect(interactor.ndFilter, NdValue.values.first);
        verify(() => mockUserPreferencesService.ndFilter).called(1);
      });

      test('ndFilter - set', () async {
        when(() => mockUserPreferencesService.ndFilter = NdValue.values.first)
            .thenReturn(NdValue.values.first);
        interactor.ndFilter = NdValue.values.first;
        verify(() => mockUserPreferencesService.ndFilter = NdValue.values.first).called(1);
      });
    },
  );

  group(
    'Volume action',
    () {
      test('volumeAction - VolumeAction.shutter', () async {
        when(() => mockUserPreferencesService.volumeAction).thenReturn(VolumeAction.shutter);
        expect(interactor.volumeAction, VolumeAction.shutter);
        verify(() => mockUserPreferencesService.volumeAction).called(1);
      });

      test('volumeAction - VolumeAction.none', () async {
        when(() => mockUserPreferencesService.volumeAction).thenReturn(VolumeAction.none);
        expect(interactor.volumeAction, VolumeAction.none);
        verify(() => mockUserPreferencesService.volumeAction).called(1);
      });
    },
  );

  group(
    'Haptics',
    () {
      test('isHapticsEnabled', () async {
        when(() => mockUserPreferencesService.haptics).thenReturn(true);
        expect(interactor.isHapticsEnabled, true);
        verify(() => mockUserPreferencesService.haptics).called(1);
      });

      test('quickVibration() - true', () async {
        when(() => mockUserPreferencesService.haptics).thenReturn(true);
        when(() => mockHapticsService.quickVibration()).thenAnswer((_) async {});
        interactor.quickVibration();
        verify(() => mockUserPreferencesService.haptics).called(1);
        verify(() => mockHapticsService.quickVibration()).called(1);
      });

      test('quickVibration() - false', () async {
        when(() => mockUserPreferencesService.haptics).thenReturn(false);
        when(() => mockHapticsService.quickVibration()).thenAnswer((_) async {});
        interactor.quickVibration();
        verify(() => mockUserPreferencesService.haptics).called(1);
        verifyNever(() => mockHapticsService.quickVibration());
      });

      test('responseVibration() - true', () async {
        when(() => mockUserPreferencesService.haptics).thenReturn(true);
        when(() => mockHapticsService.responseVibration()).thenAnswer((_) async {});
        interactor.responseVibration();
        verify(() => mockUserPreferencesService.haptics).called(1);
        verify(() => mockHapticsService.responseVibration()).called(1);
      });

      test('responseVibration() - false', () async {
        when(() => mockUserPreferencesService.haptics).thenReturn(false);
        when(() => mockHapticsService.responseVibration()).thenAnswer((_) async {});
        interactor.responseVibration();
        verify(() => mockUserPreferencesService.haptics).called(1);
        verifyNever(() => mockHapticsService.responseVibration());
      });

      test('errorVibration() - true', () async {
        when(() => mockUserPreferencesService.haptics).thenReturn(true);
        when(() => mockHapticsService.errorVibration()).thenAnswer((_) async {});
        interactor.errorVibration();
        verify(() => mockUserPreferencesService.haptics).called(1);
        verify(() => mockHapticsService.errorVibration()).called(1);
      });

      test('errorVibration() - false', () async {
        when(() => mockUserPreferencesService.haptics).thenReturn(false);
        when(() => mockHapticsService.errorVibration()).thenAnswer((_) async {});
        interactor.errorVibration();
        verify(() => mockUserPreferencesService.haptics).called(1);
        verifyNever(() => mockHapticsService.errorVibration());
      });
    },
  );

  group(
    'Permissions',
    () {
      test('checkCameraPermission() - granted', () async {
        when(() => mockPermissionsService.checkCameraPermission())
            .thenAnswer((_) async => PermissionStatus.granted);
        expectLater(interactor.checkCameraPermission(), completion(true));
        verify(() => mockPermissionsService.checkCameraPermission()).called(1);
      });

      test('checkCameraPermission() - denied', () async {
        when(() => mockPermissionsService.checkCameraPermission())
            .thenAnswer((_) async => PermissionStatus.denied);
        expectLater(interactor.checkCameraPermission(), completion(false));
        verify(() => mockPermissionsService.checkCameraPermission()).called(1);
      });

      test('requestCameraPermission() - granted', () async {
        when(() => mockPermissionsService.requestCameraPermission())
            .thenAnswer((_) async => PermissionStatus.granted);
        expectLater(interactor.requestCameraPermission(), completion(true));
        verify(() => mockPermissionsService.requestCameraPermission()).called(1);
      });

      test('requestCameraPermission() - denied', () async {
        when(() => mockPermissionsService.requestCameraPermission())
            .thenAnswer((_) async => PermissionStatus.denied);
        expectLater(interactor.requestCameraPermission(), completion(false));
        verify(() => mockPermissionsService.requestCameraPermission()).called(1);
      });
    },
  );

  group(
    'Haptics',
    () {
      test('hasAmbientLightSensor() - true', () async {
        when(() => mockLightSensorService.hasSensor()).thenAnswer((_) async => true);
        expectLater(interactor.hasAmbientLightSensor(), completion(true));
        verify(() => mockLightSensorService.hasSensor()).called(1);
      });

      test('hasAmbientLightSensor() - false', () async {
        when(() => mockLightSensorService.hasSensor()).thenAnswer((_) async => false);
        expectLater(interactor.hasAmbientLightSensor(), completion(false));
        verify(() => mockLightSensorService.hasSensor()).called(1);
      });

      test('luxStream()', () async {
        when(() => mockLightSensorService.luxStream()).thenAnswer((_) => const Stream<int>.empty());
        expect(interactor.luxStream(), const Stream<int>.empty());
        verify(() => mockLightSensorService.luxStream()).called(1);
      });
    },
  );
}
