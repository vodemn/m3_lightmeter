import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class ExposurePair {
  final ApertureValue aperture;
  final ShutterSpeedValue shutterSpeed;

  const ExposurePair(this.aperture, this.shutterSpeed);

  @override
  String toString() => '$aperture - $shutterSpeed';
}
