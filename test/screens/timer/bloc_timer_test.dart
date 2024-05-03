import 'package:bloc_test/bloc_test.dart';
import 'package:lightmeter/interactors/timer_interactor.dart';
import 'package:lightmeter/screens/timer/bloc_timer.dart';
import 'package:lightmeter/screens/timer/event_timer.dart';
import 'package:lightmeter/screens/timer/state_timer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockTimerInteractor extends Mock implements TimerInteractor {}

void main() {
  late _MockTimerInteractor meteringInteractor;
  late TimerBloc bloc;

  setUp(() {
    meteringInteractor = _MockTimerInteractor();
    when(meteringInteractor.quickVibration).thenAnswer((_) async {});
    when(meteringInteractor.responseVibration).thenAnswer((_) async {});

    bloc = TimerBloc(meteringInteractor, const Duration(seconds: 1));
  });

  tearDown(() {
    bloc.close();
  });

  blocTest<TimerBloc, TimerState>(
    'Start -> wait till the end -> reset',
    build: () => bloc,
    act: (bloc) async {
      bloc.add(const StartTimerEvent());
      bloc.add(const TimerEndedEvent());
      bloc.add(const ResetTimerEvent());
    },
    verify: (_) {
      verify(() => meteringInteractor.quickVibration()).called(1);
      verify(() => meteringInteractor.responseVibration()).called(1);
    },
    expect: () => [
      isA<TimerResumedState>(),
      isA<TimerStoppedState>(),
      isA<TimerResetState>(),
    ],
  );

  blocTest<TimerBloc, TimerState>(
    'Start -> stop -> start -> wait till the end',
    build: () => bloc,
    act: (bloc) async {
      bloc.add(const StartTimerEvent());
      bloc.add(const StopTimerEvent());
      bloc.add(const StartTimerEvent());
      bloc.add(const TimerEndedEvent());
    },
    verify: (_) {
      verify(() => meteringInteractor.quickVibration()).called(3);
      verify(() => meteringInteractor.responseVibration()).called(1);
    },
    expect: () => [
      isA<TimerResumedState>(),
      isA<TimerStoppedState>(),
      isA<TimerResumedState>(),
      isA<TimerStoppedState>(),
    ],
  );
}
