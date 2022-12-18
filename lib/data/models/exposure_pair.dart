import 'photography_values/aperture_value.dart';
import 'photography_values/shutter_speed_value.dart';

class ExposurePair {
  final ApertureValue aperture;
  final ShutterSpeedValue shutterSpeed;

  const ExposurePair(this.aperture, this.shutterSpeed);
}
