import 'package:flutter/material.dart';

@immutable
sealed class TimerState {
  final Duration duration;
  final Duration timeLeft;

  const TimerState({
    required this.duration,
    required this.timeLeft,
  });
}

class TimerStoppedState extends TimerState {
  const TimerStoppedState({
    required super.duration,
    required super.timeLeft,
  });
}

class TimerResumedState extends TimerState {
  const TimerResumedState({
    required super.duration,
    required super.timeLeft,
  });
}

class TimerResetState extends TimerStoppedState {
  const TimerResetState({
    required super.duration,
    required super.timeLeft,
  });
}
