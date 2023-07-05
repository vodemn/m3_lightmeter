import 'package:light_sensor/light_sensor.dart';
import 'package:platform/platform.dart';

class LightSensorService {
  final LocalPlatform localPlatform;

  const LightSensorService(this.localPlatform);

  Future<bool> hasSensor() async {
    if (!localPlatform.isAndroid) {
      return false;
    }
    try {
      return await LightSensor.hasSensor ?? false;
    } catch (_) {
      return false;
    }
  }

  Stream<int> luxStream() => LightSensor.lightSensorStream;
}
