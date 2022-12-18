import 'photography_value.dart';

class IsoValue extends PhotographyStopValue<int> {
  const IsoValue(super.rawValue, super.stopType);

  @override
  String toString() => value.toString();
}

const List<IsoValue> isoValues = [
  IsoValue(3, StopType.full),
  IsoValue(4, StopType.third),
  IsoValue(5, StopType.third),
  IsoValue(6, StopType.full),
  IsoValue(8, StopType.third),
  IsoValue(10, StopType.third),
  IsoValue(12, StopType.full),
  IsoValue(16, StopType.third),
  IsoValue(20, StopType.third),
  IsoValue(25, StopType.full),
  IsoValue(32, StopType.third),
  IsoValue(40, StopType.third),
  IsoValue(50, StopType.full),
  IsoValue(64, StopType.third),
  IsoValue(80, StopType.third),
  IsoValue(100, StopType.full),
  IsoValue(125, StopType.third),
  IsoValue(160, StopType.third),
  IsoValue(200, StopType.full),
  IsoValue(250, StopType.third),
  IsoValue(320, StopType.third),
  IsoValue(400, StopType.full),
  IsoValue(500, StopType.third),
  IsoValue(640, StopType.third),
  IsoValue(800, StopType.full),
  IsoValue(1000, StopType.third),
  IsoValue(1250, StopType.third),
  IsoValue(1600, StopType.full),
  IsoValue(2000, StopType.third),
  IsoValue(2500, StopType.third),
  IsoValue(3200, StopType.full),
  IsoValue(4000, StopType.third),
  IsoValue(5000, StopType.third),
  IsoValue(6400, StopType.full),
];
