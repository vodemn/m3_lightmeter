import 'package:bloc_test/bloc_test.dart';
import 'package:lightmeter/interactors/timer_interactor.dart';
import 'package:lightmeter/screens/timer/bloc_timer.dart';
import 'package:lightmeter/screens/timer/event_timer.dart';
import 'package:lightmeter/screens/timer/state_timer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockTimerInteractor extends Mock implements TimerInteractor {}

void main() {
  late _MockTimerInteractor timerInteractor;

  setUpAll(() {
    timerInteractor = _MockTimerInteractor();
    when(() => timerInteractor.isAutostartTimerEnabled).thenReturn(true);
    when(timerInteractor.quickVibration).thenAnswer((_) async {});
    when(timerInteractor.responseVibration).thenAnswer((_) async {});
  });

  blocTest<TimerBloc, TimerState>(
    'Autostart',
    build: () => TimerBloc(timerInteractor, const Duration(seconds: 1)),
    verify: (_) {
      verify(() => timerInteractor.quickVibration()).called(1);
    },
    expect: () => [
      isA<TimerResumedState>(),
    ],
  );

  blocTest<TimerBloc, TimerState>(
    'Start -> wait till the end -> reset',
    build: () => TimerBloc(timerInteractor, const Duration(seconds: 1)),
    setUp: () {
      when(() => timerInteractor.isAutostartTimerEnabled).thenReturn(false);
    },
    act: (bloc) {
      bloc.add(const StartTimerEvent());
      bloc.add(const TimerEndedEvent());
      bloc.add(const ResetTimerEvent());
    },
    verify: (_) {
      verify(() => timerInteractor.quickVibration()).called(1);
      verify(() => timerInteractor.responseVibration()).called(1);
    },
    expect: () => [
      isA<TimerResumedState>(),
      isA<TimerStoppedState>(),
      isA<TimerResetState>(),
    ],
  );

  blocTest<TimerBloc, TimerState>(
    'Start -> stop -> start -> wait till the end',
    build: () => TimerBloc(timerInteractor, const Duration(seconds: 1)),
    setUp: () {
      when(() => timerInteractor.isAutostartTimerEnabled).thenReturn(false);
    },
    act: (bloc) async {
      bloc.add(const StartTimerEvent());
      bloc.add(const StopTimerEvent());
      bloc.add(const StartTimerEvent());
      bloc.add(const TimerEndedEvent());
    },
    verify: (_) {
      verify(() => timerInteractor.quickVibration()).called(3);
      verify(() => timerInteractor.responseVibration()).called(1);
    },
    expect: () => [
      isA<TimerResumedState>(),
      isA<TimerStoppedState>(),
      isA<TimerResumedState>(),
      isA<TimerStoppedState>(),
    ],
  );
}
