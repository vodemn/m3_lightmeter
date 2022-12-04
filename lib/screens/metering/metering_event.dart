import 'package:lightmeter/models/photography_value.dart';

abstract class MeteringEvent {
  const MeteringEvent();
}

class IsoChangedEvent extends MeteringEvent {
  final IsoValue isoValue;

  const IsoChangedEvent(this.isoValue);
}

class MeasureEvent extends MeteringEvent {
  const MeasureEvent();
}
