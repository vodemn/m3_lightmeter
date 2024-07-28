import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserPreferencesService extends Mock implements UserPreferencesService {}

class _MockCaffeineService extends Mock implements CaffeineService {}

class _MockHapticsService extends Mock implements HapticsService {}

class _MockVolumeEventsService extends Mock implements VolumeEventsService {}

void main() {
  late _MockUserPreferencesService mockUserPreferencesService;
  late _MockCaffeineService mockCaffeineService;
  late _MockHapticsService mockHapticsService;
  late _MockVolumeEventsService mockVolumeEventsService;

  late SettingsInteractor interactor;

  setUp(() {
    mockUserPreferencesService = _MockUserPreferencesService();
    mockCaffeineService = _MockCaffeineService();
    mockHapticsService = _MockHapticsService();
    mockVolumeEventsService = _MockVolumeEventsService();

    interactor = SettingsInteractor(
      mockUserPreferencesService,
      mockCaffeineService,
      mockHapticsService,
      mockVolumeEventsService,
    );
  });

  group(
    'Calibration',
    () {
      test('cameraEvCalibration - get', () async {
        when(() => mockUserPreferencesService.cameraEvCalibration).thenReturn(0.0);
        expect(interactor.cameraEvCalibration, 0.0);
        verify(() => mockUserPreferencesService.cameraEvCalibration).called(1);
      });

      test('cameraEvCalibration - set', () async {
        when(() => mockUserPreferencesService.cameraEvCalibration = 0.0).thenReturn(0.0);
        interactor.setCameraEvCalibration(0.0);
        verify(() => mockUserPreferencesService.cameraEvCalibration = 0.0).called(1);
      });

      test('lightSensorEvCalibration - get', () async {
        when(() => mockUserPreferencesService.lightSensorEvCalibration).thenReturn(0.0);
        expect(interactor.lightSensorEvCalibration, 0.0);
        verify(() => mockUserPreferencesService.lightSensorEvCalibration).called(1);
      });

      test('lightSensorEvCalibration - set', () async {
        when(() => mockUserPreferencesService.lightSensorEvCalibration = 0.0).thenReturn(0.0);
        interactor.setLightSensorEvCalibration(0.0);
        verify(() => mockUserPreferencesService.lightSensorEvCalibration = 0.0).called(1);
      });
    },
  );

  group(
    'Caffeine',
    () {
      test('isCaffeineEnabled', () async {
        when(() => mockUserPreferencesService.caffeine).thenReturn(true);
        expect(interactor.isCaffeineEnabled, true);
        verify(() => mockUserPreferencesService.caffeine).called(1);
      });

      test('enableCaffeine(true)', () async {
        when(() => mockCaffeineService.keepScreenOn(true)).thenAnswer((_) async => true);
        when(() => mockUserPreferencesService.caffeine = true).thenReturn(true);
        await interactor.enableCaffeine(true);
        verify(() => mockCaffeineService.keepScreenOn(true)).called(1);
        verify(() => mockUserPreferencesService.caffeine = true).called(1);
      });
    },
  );

  group(
    'AutostartTimer',
    () {
      test('isAutostartTimerEnabled', () {
        when(() => mockUserPreferencesService.autostartTimer).thenReturn(true);
        expect(interactor.isAutostartTimerEnabled, true);
        when(() => mockUserPreferencesService.autostartTimer).thenReturn(false);
        expect(interactor.isAutostartTimerEnabled, false);
        verify(() => mockUserPreferencesService.autostartTimer).called(2);
      });

      test('enableAutostartTimer(true)', () {
        when(() => mockUserPreferencesService.autostartTimer = true).thenReturn(true);
        interactor.enableAutostartTimer(true);
        verify(() => mockUserPreferencesService.autostartTimer = true).called(1);
        when(() => mockUserPreferencesService.autostartTimer = true).thenReturn(false);
        interactor.enableAutostartTimer(false);
        verify(() => mockUserPreferencesService.autostartTimer = false).called(1);
      });
    },
  );

  group(
    'Volume action',
    () {
      test('disableVolumeHandling()', () async {
        when(() => mockVolumeEventsService.setVolumeHandling(false)).thenAnswer((_) async => false);
        expectLater(interactor.disableVolumeHandling(), isA<Future<void>>());
        verify(() => mockVolumeEventsService.setVolumeHandling(false)).called(1);
      });

      test('restoreVolumeHandling() - VolumeAction.shutter', () async {
        when(() => mockUserPreferencesService.volumeAction).thenReturn(VolumeAction.shutter);
        when(() => mockVolumeEventsService.setVolumeHandling(true)).thenAnswer((_) async => true);
        expectLater(interactor.restoreVolumeHandling(), isA<Future<void>>());
        verify(() => mockUserPreferencesService.volumeAction).called(1);
        verify(() => mockVolumeEventsService.setVolumeHandling(true)).called(1);
      });

      test('restoreVolumeHandling() - VolumeAction.none', () async {
        when(() => mockUserPreferencesService.volumeAction).thenReturn(VolumeAction.none);
        when(() => mockVolumeEventsService.setVolumeHandling(false)).thenAnswer((_) async => false);
        expectLater(interactor.restoreVolumeHandling(), isA<Future<void>>());
        verify(() => mockUserPreferencesService.volumeAction).called(1);
        verify(() => mockVolumeEventsService.setVolumeHandling(false)).called(1);
      });

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

      test('setVolumeAction(VolumeAction.shutter)', () async {
        when(() => mockUserPreferencesService.volumeAction = VolumeAction.shutter).thenReturn(VolumeAction.shutter);
        when(() => mockVolumeEventsService.setVolumeHandling(true)).thenAnswer((_) async => true);
        expectLater(interactor.setVolumeAction(VolumeAction.shutter), isA<Future<void>>());
        verify(() => mockVolumeEventsService.setVolumeHandling(true)).called(1);
        verify(() => mockUserPreferencesService.volumeAction = VolumeAction.shutter).called(1);
      });

      test('setVolumeAction(VolumeAction.none)', () async {
        when(() => mockUserPreferencesService.volumeAction = VolumeAction.none).thenReturn(VolumeAction.none);
        when(() => mockVolumeEventsService.setVolumeHandling(false)).thenAnswer((_) async => false);
        expectLater(interactor.setVolumeAction(VolumeAction.none), isA<Future<void>>());
        verify(() => mockVolumeEventsService.setVolumeHandling(false)).called(1);
        verify(() => mockUserPreferencesService.volumeAction = VolumeAction.none).called(1);
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

      test('enableHaptics() - true', () async {
        when(() => mockUserPreferencesService.haptics = true).thenReturn(true);
        when(() => mockUserPreferencesService.haptics).thenReturn(true);
        when(() => mockHapticsService.quickVibration()).thenAnswer((_) async {});
        interactor.enableHaptics(true);
        verify(() => mockUserPreferencesService.haptics).called(1);
        verify(() => mockHapticsService.quickVibration()).called(1);
      });

      test('enableHaptics() - false', () async {
        when(() => mockUserPreferencesService.haptics = false).thenReturn(false);
        when(() => mockUserPreferencesService.haptics).thenReturn(false);
        when(() => mockHapticsService.quickVibration()).thenAnswer((_) async {});
        interactor.enableHaptics(false);
        verify(() => mockUserPreferencesService.haptics).called(1);
        verifyNever(() => mockHapticsService.quickVibration());
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
    },
  );
}
