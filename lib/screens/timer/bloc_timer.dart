import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/screens/timer/event_timer.dart';
import 'package:lightmeter/screens/timer/state_timer.dart';

const _kTimerStep = Duration(milliseconds: 1);

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final MeteringInteractor _meteringInteractor;
  late Timer? _timer;
  final Duration duration;

  TimerBloc(this._meteringInteractor, this.duration)
      : super(
          TimerStoppedState(
            duration: duration,
            timeLeft: duration,
          ),
        ) {
    on<StartTimerEvent>(_onStartTimer);
    on<SetTimeLeftEvent>(_onSetTimeLeft);
    on<StopTimerEvent>(_onStopTimer);
    on<ResetTimerEvent>(_onResetTimer);
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    return super.close();
  }

  Future<void> _onStartTimer(StartTimerEvent _, Emitter emit) async {
    emit(
      TimerResumedState(
        duration: state.duration,
        timeLeft: state.timeLeft,
      ),
    );

    _timer = Timer.periodic(_kTimerStep, (_) {
      if (state.timeLeft.inMilliseconds == 0) {
        add(const StopTimerEvent());
      } else {
        add(SetTimeLeftEvent(state.timeLeft - _kTimerStep));
      }
    });
  }

  Future<void> _onSetTimeLeft(SetTimeLeftEvent event, Emitter emit) async {
    emit(
      TimerResumedState(
        duration: state.duration,
        timeLeft: event.timeLeft,
      ),
    );
  }

  Future<void> _onStopTimer(StopTimerEvent _, Emitter emit) async {
    _timer?.cancel();
    emit(
      TimerStoppedState(
        duration: state.duration,
        timeLeft: state.timeLeft,
      ),
    );
  }

  Future<void> _onResetTimer(ResetTimerEvent _, Emitter emit) async {
    _timer?.cancel();
    emit(
      TimerResetState(
        duration: state.duration,
        timeLeft: state.duration,
      ),
    );
  }
}
