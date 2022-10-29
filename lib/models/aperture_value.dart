part of 'photography_value.dart';

class ApertureValue extends PhotographyValue<double> {
  const ApertureValue(super.rawValue, super.stopType);

  @override
  double get value => rawValue;

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
  ApertureValue(1.0, Stop.full),
  ApertureValue(1.1, Stop.third),
  ApertureValue(1.2, Stop.half),
  ApertureValue(1.2, Stop.third),
  ApertureValue(1.4, Stop.full),
  ApertureValue(1.6, Stop.third),
  ApertureValue(1.7, Stop.half),
  ApertureValue(1.8, Stop.third),
  ApertureValue(2.0, Stop.full),
  ApertureValue(2.2, Stop.third),
  ApertureValue(2.4, Stop.half),
  ApertureValue(2.4, Stop.third),
  ApertureValue(2.8, Stop.full),
  ApertureValue(3.2, Stop.third),
  ApertureValue(3.3, Stop.half),
  ApertureValue(3.5, Stop.third),
  ApertureValue(4.0, Stop.full),
  ApertureValue(4.5, Stop.third),
  ApertureValue(4.8, Stop.half),
  ApertureValue(5.0, Stop.third),
  ApertureValue(5.6, Stop.full),
  ApertureValue(6.3, Stop.third),
  ApertureValue(6.7, Stop.half),
  ApertureValue(7.1, Stop.third),
  ApertureValue(8, Stop.full),
  ApertureValue(9, Stop.third),
  ApertureValue(9.5, Stop.half),
  ApertureValue(10, Stop.third),
  ApertureValue(11, Stop.full),
  ApertureValue(13, Stop.third),
  ApertureValue(13, Stop.half),
  ApertureValue(14, Stop.third),
  ApertureValue(16, Stop.full),
  ApertureValue(18, Stop.third),
  ApertureValue(19, Stop.half),
  ApertureValue(20, Stop.third),
  ApertureValue(22, Stop.full),
  ApertureValue(25, Stop.third),
  ApertureValue(27, Stop.half),
  ApertureValue(29, Stop.third),
  ApertureValue(32, Stop.full),
  ApertureValue(36, Stop.third),
  ApertureValue(38, Stop.half),
  ApertureValue(42, Stop.third),
  ApertureValue(45, Stop.full),
];
