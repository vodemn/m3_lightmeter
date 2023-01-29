import 'package:light_sensor/light_sensor.dart';

class LightSensorService {
  const LightSensorService();

  Future<bool> hasSensor() async => await LightSensor.hasSensor ?? false;

  Stream<int> luxStream() => LightSensor.lightSensorStream;
}
