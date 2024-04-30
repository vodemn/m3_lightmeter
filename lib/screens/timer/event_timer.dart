sealed class TimerEvent {
  const TimerEvent();
}

class StartTimerEvent extends TimerEvent {
  const StartTimerEvent();
}

class StopTimerEvent extends TimerEvent {
  const StopTimerEvent();
}

class SetTimeLeftEvent extends TimerEvent {
  final Duration timeLeft;

  const SetTimeLeftEvent(this.timeLeft);
}

class ResetTimerEvent extends TimerEvent {
  const ResetTimerEvent();
}
