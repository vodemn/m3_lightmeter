import 'package:light_sensor/light_sensor.dart';

class LightSensorService {
  const LightSensorService();

  Future<bool> hasSensor() async {
    try {
      return await LightSensor.hasSensor ?? false;
    } catch (_) {
      return false;
    }
  }

  Stream<int> luxStream() => LightSensor.lightSensorStream;
}
