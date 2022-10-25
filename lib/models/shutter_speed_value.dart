part of 'photography_value.dart';

class ShutterSpeedValue extends PhotographyValue<double> {
  final bool isFraction;

  const ShutterSpeedValue(super.rawValue, this.isFraction, super.stopType);

  @override
  double get value => isFraction ? 1 / rawValue : rawValue;

  @override
  String toString() {
    final buffer = StringBuffer();
    if (isFraction) buffer.write("1/");
    if (rawValue - rawValue.floor() == 0) {
      buffer.write(rawValue.toInt().toString());
    } else {
      buffer.write(rawValue.toStringAsFixed(1));
    }
    if (!isFraction) buffer.write("\"");
    return buffer.toString();
  }
}

const List<ShutterSpeedValue> shutterSpeedValues = [
  ShutterSpeedValue(2000, true, Stop.full),
  ShutterSpeedValue(1600, true, Stop.third),
  ShutterSpeedValue(1500, true, Stop.half),
  ShutterSpeedValue(1250, true, Stop.third),
  ShutterSpeedValue(1000, true, Stop.full),
  ShutterSpeedValue(800, true, Stop.third),
  ShutterSpeedValue(750, true, Stop.half),
  ShutterSpeedValue(640, true, Stop.third),
  ShutterSpeedValue(500, true, Stop.full),
  ShutterSpeedValue(400, true, Stop.third),
  ShutterSpeedValue(350, true, Stop.half),
  ShutterSpeedValue(320, true, Stop.third),
  ShutterSpeedValue(250, true, Stop.full),
  ShutterSpeedValue(200, true, Stop.third),
  ShutterSpeedValue(180, true, Stop.half),
  ShutterSpeedValue(160, true, Stop.third),
  ShutterSpeedValue(125, true, Stop.full),
  ShutterSpeedValue(100, true, Stop.third),
  ShutterSpeedValue(90, true, Stop.half),
  ShutterSpeedValue(80, true, Stop.third),
  ShutterSpeedValue(60, true, Stop.full),
  ShutterSpeedValue(50, true, Stop.third),
  ShutterSpeedValue(45, true, Stop.half),
  ShutterSpeedValue(40, true, Stop.third),
  ShutterSpeedValue(30, true, Stop.full),
  ShutterSpeedValue(25, true, Stop.third),
  ShutterSpeedValue(20, true, Stop.half),
  ShutterSpeedValue(20, true, Stop.third),
  ShutterSpeedValue(15, true, Stop.full),
  ShutterSpeedValue(13, true, Stop.third),
  ShutterSpeedValue(10, true, Stop.half),
  ShutterSpeedValue(10, true, Stop.third),
  ShutterSpeedValue(8, true, Stop.full),
  ShutterSpeedValue(6, true, Stop.third),
  ShutterSpeedValue(6, true, Stop.half),
  ShutterSpeedValue(5, true, Stop.third),
  ShutterSpeedValue(4, true, Stop.full),
  ShutterSpeedValue(3, true, Stop.third),
  ShutterSpeedValue(3, true, Stop.half),
  ShutterSpeedValue(2.5, true, Stop.third),
  ShutterSpeedValue(2, true, Stop.full),
  ShutterSpeedValue(1.6, true, Stop.third),
  ShutterSpeedValue(1.5, true, Stop.half),
  ShutterSpeedValue(1.3, true, Stop.third),
  ShutterSpeedValue(1, false, Stop.full),
  ShutterSpeedValue(1.3, false, Stop.third),
  ShutterSpeedValue(1.5, false, Stop.half),
  ShutterSpeedValue(1.6, false, Stop.third),
  ShutterSpeedValue(2, false, Stop.full),
  ShutterSpeedValue(2.5, false, Stop.third),
  ShutterSpeedValue(3, false, Stop.half),
  ShutterSpeedValue(3, false, Stop.third),
  ShutterSpeedValue(4, false, Stop.full),
  ShutterSpeedValue(5, false, Stop.third),
  ShutterSpeedValue(6, false, Stop.half),
  ShutterSpeedValue(6, false, Stop.third),
  ShutterSpeedValue(8, false, Stop.full),
  ShutterSpeedValue(10, false, Stop.third),
  ShutterSpeedValue(12, false, Stop.half),
  ShutterSpeedValue(13, false, Stop.third),
  ShutterSpeedValue(16, false, Stop.full),
];
