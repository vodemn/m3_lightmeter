import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';

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
        when(() => mockUserPreferencesService.volumeAction = VolumeAction.shutter)
            .thenReturn(VolumeAction.shutter);
        when(() => mockVolumeEventsService.setVolumeHandling(true)).thenAnswer((_) async => true);
        expectLater(interactor.setVolumeAction(VolumeAction.shutter), isA<Future<void>>());
        verify(() => mockVolumeEventsService.setVolumeHandling(true)).called(1);
        verify(() => mockUserPreferencesService.volumeAction = VolumeAction.shutter).called(1);
      });

      test('setVolumeAction(VolumeAction.none)', () async {
        when(() => mockUserPreferencesService.volumeAction = VolumeAction.none)
            .thenReturn(VolumeAction.none);
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
