import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

abstract class MeteringCommunicationEvent {
  const MeteringCommunicationEvent();
}

/// Events sent by the screen to the current metering source.
abstract class ScreenEvent extends MeteringCommunicationEvent {
  const ScreenEvent();
}

/// Event sent by the current metering source in response for the screen events.
abstract class SourceEvent extends MeteringCommunicationEvent {
  const SourceEvent();
}

class MeasureEvent extends ScreenEvent {
  const MeasureEvent();
}

class EquipmentProfileChangedEvent extends ScreenEvent {
  final EquipmentProfile profile;

  const EquipmentProfileChangedEvent(this.profile);
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
