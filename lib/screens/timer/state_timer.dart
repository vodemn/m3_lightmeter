import 'package:flutter/material.dart';

@immutable
sealed class TimerState {
  const TimerState();
}

class TimerStoppedState extends TimerState {
  const TimerStoppedState();
}

class TimerResumedState extends TimerState {
  const TimerResumedState();
}

class TimerResetState extends TimerStoppedState {
  const TimerResetState();
}
