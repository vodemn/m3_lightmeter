abstract class MeteringCommunicationEvent {
  const MeteringCommunicationEvent();
}

abstract class SourceEvent extends MeteringCommunicationEvent {
  const SourceEvent();
}

abstract class ScreenEvent extends MeteringCommunicationEvent {
  const ScreenEvent();
}

class MeasureEvent extends ScreenEvent {
  const MeasureEvent();
}

abstract class MeasuredEvent extends SourceEvent {
  final double ev100;

  const MeasuredEvent(this.ev100);
}

class MeteringInProgressEvent extends MeasuredEvent {
  const MeteringInProgressEvent(super.ev100);
}

class MeteringEndedEvent extends MeasuredEvent {
  const MeteringEndedEvent(super.ev100);
}
