import 'photography_value.dart';

class ShutterSpeedValue extends PhotographyStopValue<double> {
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
  ShutterSpeedValue(2000, true, StopType.full),
  ShutterSpeedValue(1600, true, StopType.third),
  ShutterSpeedValue(1500, true, StopType.half),
  ShutterSpeedValue(1250, true, StopType.third),
  ShutterSpeedValue(1000, true, StopType.full),
  ShutterSpeedValue(800, true, StopType.third),
  ShutterSpeedValue(750, true, StopType.half),
  ShutterSpeedValue(640, true, StopType.third),
  ShutterSpeedValue(500, true, StopType.full),
  ShutterSpeedValue(400, true, StopType.third),
  ShutterSpeedValue(350, true, StopType.half),
  ShutterSpeedValue(320, true, StopType.third),
  ShutterSpeedValue(250, true, StopType.full),
  ShutterSpeedValue(200, true, StopType.third),
  ShutterSpeedValue(180, true, StopType.half),
  ShutterSpeedValue(160, true, StopType.third),
  ShutterSpeedValue(125, true, StopType.full),
  ShutterSpeedValue(100, true, StopType.third),
  ShutterSpeedValue(90, true, StopType.half),
  ShutterSpeedValue(80, true, StopType.third),
  ShutterSpeedValue(60, true, StopType.full),
  ShutterSpeedValue(50, true, StopType.third),
  ShutterSpeedValue(45, true, StopType.half),
  ShutterSpeedValue(40, true, StopType.third),
  ShutterSpeedValue(30, true, StopType.full),
  ShutterSpeedValue(25, true, StopType.third),
  ShutterSpeedValue(20, true, StopType.half),
  ShutterSpeedValue(20, true, StopType.third),
  ShutterSpeedValue(15, true, StopType.full),
  ShutterSpeedValue(13, true, StopType.third),
  ShutterSpeedValue(10, true, StopType.half),
  ShutterSpeedValue(10, true, StopType.third),
  ShutterSpeedValue(8, true, StopType.full),
  ShutterSpeedValue(6, true, StopType.third),
  ShutterSpeedValue(6, true, StopType.half),
  ShutterSpeedValue(5, true, StopType.third),
  ShutterSpeedValue(4, true, StopType.full),
  ShutterSpeedValue(3, true, StopType.third),
  ShutterSpeedValue(3, true, StopType.half),
  ShutterSpeedValue(2.5, true, StopType.third),
  ShutterSpeedValue(2, true, StopType.full),
  ShutterSpeedValue(1.6, true, StopType.third),
  ShutterSpeedValue(1.5, true, StopType.half),
  ShutterSpeedValue(1.3, true, StopType.third),
  ShutterSpeedValue(1, false, StopType.full),
  ShutterSpeedValue(1.3, false, StopType.third),
  ShutterSpeedValue(1.5, false, StopType.half),
  ShutterSpeedValue(1.6, false, StopType.third),
  ShutterSpeedValue(2, false, StopType.full),
  ShutterSpeedValue(2.5, false, StopType.third),
  ShutterSpeedValue(3, false, StopType.half),
  ShutterSpeedValue(3, false, StopType.third),
  ShutterSpeedValue(4, false, StopType.full),
  ShutterSpeedValue(5, false, StopType.third),
  ShutterSpeedValue(6, false, StopType.half),
  ShutterSpeedValue(6, false, StopType.third),
  ShutterSpeedValue(8, false, StopType.full),
  ShutterSpeedValue(10, false, StopType.third),
  ShutterSpeedValue(12, false, StopType.half),
  ShutterSpeedValue(13, false, StopType.third),
  ShutterSpeedValue(16, false, StopType.full),
];
