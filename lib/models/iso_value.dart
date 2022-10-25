part of 'photography_value.dart';

class IsoValue extends PhotographyValue<int> {
  const IsoValue(super.rawValue, super.stopType);

  @override
  int get value => rawValue;

  @override
  String toString() => value.toString();
}

const List<IsoValue> isoValues = [
  IsoValue(3, Stop.full),
  IsoValue(4, Stop.third),
  IsoValue(5, Stop.third),
  IsoValue(6, Stop.full),
  IsoValue(8, Stop.third),
  IsoValue(10, Stop.third),
  IsoValue(12, Stop.full),
  IsoValue(16, Stop.third),
  IsoValue(20, Stop.third),
  IsoValue(25, Stop.full),
  IsoValue(32, Stop.third),
  IsoValue(40, Stop.third),
  IsoValue(50, Stop.full),
  IsoValue(64, Stop.third),
  IsoValue(80, Stop.third),
  IsoValue(100, Stop.full),
  IsoValue(125, Stop.third),
  IsoValue(160, Stop.third),
  IsoValue(200, Stop.full),
  IsoValue(250, Stop.third),
  IsoValue(320, Stop.third),
  IsoValue(400, Stop.full),
  IsoValue(500, Stop.third),
  IsoValue(640, Stop.third),
  IsoValue(800, Stop.full),
  IsoValue(1000, Stop.third),
  IsoValue(1250, Stop.third),
  IsoValue(1600, Stop.full),
  IsoValue(2000, Stop.third),
  IsoValue(2500, Stop.third),
  IsoValue(3200, Stop.full),
  IsoValue(4000, Stop.third),
  IsoValue(5000, Stop.third),
  IsoValue(6400, Stop.full),
];
