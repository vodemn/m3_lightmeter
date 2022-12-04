import 'aperture_value.dart';
import 'shutter_speed_value.dart';

class ExposurePair {
  final ApertureValue aperture;
  final ShutterSpeedValue shutterSpeed;

  const ExposurePair(this.aperture, this.shutterSpeed);
}
