sealed class TimerEvent {
  const TimerEvent();
}

class StartTimerEvent extends TimerEvent {
  const StartTimerEvent();
}

class StopTimerEvent extends TimerEvent {
  const StopTimerEvent();
}

class TimerEndedEvent extends TimerEvent {
  const TimerEndedEvent();
}

class ResetTimerEvent extends TimerEvent {
  const ResetTimerEvent();
}
