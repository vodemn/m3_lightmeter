import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

abstract class MeteringEvent {
  const MeteringEvent();
}

class StopTypeChangedEvent extends MeteringEvent {
  final StopType stopType;

  const StopTypeChangedEvent(this.stopType);
}

class IsoChangedEvent extends MeteringEvent {
  final IsoValue isoValue;

  const IsoChangedEvent(this.isoValue);
}

class NdChangedEvent extends MeteringEvent {
  final NdValue ndValue;

  const NdChangedEvent(this.ndValue);
}

class MeasureEvent extends MeteringEvent {
  const MeasureEvent();
}

class MeasuredEvent extends MeteringEvent {
  final double ev100;

  const MeasuredEvent(this.ev100);
}
