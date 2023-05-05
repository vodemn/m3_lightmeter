abstract class MeteringCommunicationState {
  const MeteringCommunicationState();
}

class InitState extends MeteringCommunicationState {
  const InitState();
}

abstract class SourceState extends MeteringCommunicationState {
  const SourceState();
}

abstract class ScreenState extends MeteringCommunicationState {
  const ScreenState();
}

class MeasureState extends SourceState {
  const MeasureState();
}

abstract class MeasuredState extends ScreenState {
  final double? ev100;

  const MeasuredState(this.ev100);
}

class MeteringInProgressState extends MeasuredState {
  const MeteringInProgressState(super.ev100);
}

class MeteringEndedState extends MeasuredState {
  const MeteringEndedState(super.ev100);
}
