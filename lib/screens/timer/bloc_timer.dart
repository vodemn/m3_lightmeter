import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/timer_interactor.dart';
import 'package:lightmeter/screens/timer/event_timer.dart';
import 'package:lightmeter/screens/timer/state_timer.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final TimerInteractor _timerInteractor;
  final Duration duration;

  TimerBloc(this._timerInteractor, this.duration) : super(const TimerStoppedState()) {
    on<StartTimerEvent>(_onStartTimer);
    on<TimerEndedEvent>(_onTimerEnded);
    on<StopTimerEvent>(_onStopTimer);
    on<ResetTimerEvent>(_onResetTimer);
  }

  Future<void> _onStartTimer(StartTimerEvent _, Emitter emit) async {
    _timerInteractor.quickVibration();
    emit(const TimerResumedState());
  }

  Future<void> _onTimerEnded(TimerEndedEvent event, Emitter emit) async {
    if (state is! TimerResetState) {
      _timerInteractor.responseVibration();
      emit(const TimerStoppedState());
    }
  }

  Future<void> _onStopTimer(StopTimerEvent _, Emitter emit) async {
    _timerInteractor.quickVibration();
    emit(const TimerStoppedState());
  }

  Future<void> _onResetTimer(ResetTimerEvent _, Emitter emit) async {
    emit(const TimerResetState());
  }
}
