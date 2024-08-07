import 'package:light_sensor/light_sensor.dart';
import 'package:platform/platform.dart';

class LightSensorService {
  final LocalPlatform localPlatform;

  const LightSensorService(this.localPlatform);

  Future<bool> hasSensor() async {
    if (localPlatform.isIOS) {
      return false;
    }
    try {
      return await LightSensor.hasSensor();
    } catch (_) {
      return false;
    }
  }

  Stream<int> luxStream() {
    if (localPlatform.isIOS) {
      return const Stream<int>.empty();
    }
    return LightSensor.luxStream();
  }
}
