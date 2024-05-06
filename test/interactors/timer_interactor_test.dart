import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/interactors/timer_interactor.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserPreferencesService extends Mock implements UserPreferencesService {}

class _MockHapticsService extends Mock implements HapticsService {}

void main() {
  late _MockUserPreferencesService mockUserPreferencesService;
  late _MockHapticsService mockHapticsService;

  late TimerInteractor interactor;

  setUp(() {
    mockUserPreferencesService = _MockUserPreferencesService();
    mockHapticsService = _MockHapticsService();

    interactor = TimerInteractor(
      mockUserPreferencesService,
      mockHapticsService,
    );
  });

  group(
    'Haptics',
    () {
      test('startVibration() - true', () async {
        when(() => mockUserPreferencesService.haptics).thenReturn(true);
        when(() => mockHapticsService.quickVibration()).thenAnswer((_) async {});
        interactor.startVibration();
        verify(() => mockUserPreferencesService.haptics).called(1);
        verify(() => mockHapticsService.quickVibration()).called(1);
      });

      test('startVibration() - false', () async {
        when(() => mockUserPreferencesService.haptics).thenReturn(false);
        when(() => mockHapticsService.quickVibration()).thenAnswer((_) async {});
        interactor.startVibration();
        verify(() => mockUserPreferencesService.haptics).called(1);
        verifyNever(() => mockHapticsService.quickVibration());
      });

      test('endVibration() - true', () async {
        when(() => mockUserPreferencesService.haptics).thenReturn(true);
        when(() => mockHapticsService.errorVibration()).thenAnswer((_) async {});
        interactor.endVibration();
        verify(() => mockUserPreferencesService.haptics).called(1);
        verify(() => mockHapticsService.errorVibration()).called(1);
      });

      test('endVibration() - false', () async {
        when(() => mockUserPreferencesService.haptics).thenReturn(false);
        when(() => mockHapticsService.errorVibration()).thenAnswer((_) async {});
        interactor.endVibration();
        verify(() => mockUserPreferencesService.haptics).called(1);
        verifyNever(() => mockHapticsService.errorVibration());
      });
    },
  );

  group(
    'AutostartTimer',
    () {
      test('isAutostartTimerEnabled', () {
        when(() => mockUserPreferencesService.autostartTimer).thenReturn(true);
        expect(interactor.isAutostartTimerEnabled, true);
        verify(() => mockUserPreferencesService.autostartTimer).called(1);
      });
    },
  );
}
