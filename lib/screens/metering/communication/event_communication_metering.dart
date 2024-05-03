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
  final double? ev100;

  const MeasuredEvent(this.ev100);
}

class MeteringInProgressEvent extends MeasuredEvent {
  const MeteringInProgressEvent(super.ev100);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is MeteringInProgressEvent && other.ev100 == ev100;
  }

  @override
  int get hashCode => Object.hash(ev100, runtimeType);
}

class MeteringEndedEvent extends MeasuredEvent {
  const MeteringEndedEvent(super.ev100);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is MeteringEndedEvent && other.ev100 == ev100;
  }

  @override
  int get hashCode => Object.hash(ev100, runtimeType);
}

class ScreenOnTopOpenedEvent extends ScreenEvent {
  const ScreenOnTopOpenedEvent();
}

class ScreenOnTopClosedEvent extends ScreenEvent {
  const ScreenOnTopClosedEvent();
}
