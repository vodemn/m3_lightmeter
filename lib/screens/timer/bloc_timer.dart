import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/screens/timer/event_timer.dart';
import 'package:lightmeter/screens/timer/state_timer.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final MeteringInteractor _meteringInteractor;
  final Duration duration;

  TimerBloc(this._meteringInteractor, this.duration) : super(const TimerStoppedState()) {
    on<StartTimerEvent>(_onStartTimer);
    on<SetTimeLeftEvent>(_onSetTimeLeft);
    on<StopTimerEvent>(_onStopTimer);
    on<ResetTimerEvent>(_onResetTimer);
  }

  Future<void> _onStartTimer(StartTimerEvent _, Emitter emit) async {
    emit(const TimerResumedState());
  }

  Future<void> _onSetTimeLeft(SetTimeLeftEvent event, Emitter emit) async {
    emit(const TimerResumedState());
  }

  Future<void> _onStopTimer(StopTimerEvent _, Emitter emit) async {
    emit(const TimerStoppedState());
  }

  Future<void> _onResetTimer(ResetTimerEvent _, Emitter emit) async {
    emit(const TimerResetState());
  }
}
