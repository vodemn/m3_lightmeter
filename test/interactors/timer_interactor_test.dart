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
