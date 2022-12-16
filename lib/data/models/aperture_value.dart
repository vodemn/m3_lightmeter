import 'photography_value.dart';

class ApertureValue extends PhotographyStopValue<double> {
  const ApertureValue(super.rawValue, super.stopType);

  @override
  String toString() {
    final buffer = StringBuffer("f/");
    if (rawValue - rawValue.floor() == 0 && rawValue >= 8) {
      buffer.write(rawValue.toInt().toString());
    } else {
      buffer.write(rawValue.toStringAsFixed(1));
    }
    return buffer.toString();
  }
}

const List<ApertureValue> apertureValues = [
  ApertureValue(1.0, StopType.full),
  ApertureValue(1.1, StopType.third),
  ApertureValue(1.2, StopType.half),
  ApertureValue(1.2, StopType.third),
  ApertureValue(1.4, StopType.full),
  ApertureValue(1.6, StopType.third),
  ApertureValue(1.7, StopType.half),
  ApertureValue(1.8, StopType.third),
  ApertureValue(2.0, StopType.full),
  ApertureValue(2.2, StopType.third),
  ApertureValue(2.4, StopType.half),
  ApertureValue(2.4, StopType.third),
  ApertureValue(2.8, StopType.full),
  ApertureValue(3.2, StopType.third),
  ApertureValue(3.3, StopType.half),
  ApertureValue(3.5, StopType.third),
  ApertureValue(4.0, StopType.full),
  ApertureValue(4.5, StopType.third),
  ApertureValue(4.8, StopType.half),
  ApertureValue(5.0, StopType.third),
  ApertureValue(5.6, StopType.full),
  ApertureValue(6.3, StopType.third),
  ApertureValue(6.7, StopType.half),
  ApertureValue(7.1, StopType.third),
  ApertureValue(8, StopType.full),
  ApertureValue(9, StopType.third),
  ApertureValue(9.5, StopType.half),
  ApertureValue(10, StopType.third),
  ApertureValue(11, StopType.full),
  ApertureValue(13, StopType.third),
  ApertureValue(13, StopType.half),
  ApertureValue(14, StopType.third),
  ApertureValue(16, StopType.full),
  ApertureValue(18, StopType.third),
  ApertureValue(19, StopType.half),
  ApertureValue(20, StopType.third),
  ApertureValue(22, StopType.full),
  ApertureValue(25, StopType.third),
  ApertureValue(27, StopType.half),
  ApertureValue(29, StopType.third),
  ApertureValue(32, StopType.full),
  ApertureValue(36, StopType.third),
  ApertureValue(38, StopType.half),
  ApertureValue(42, StopType.third),
  ApertureValue(45, StopType.full),
];
