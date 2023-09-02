import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class ExposurePair {
  final ApertureValue aperture;
  final ShutterSpeedValue shutterSpeed;

  const ExposurePair(this.aperture, this.shutterSpeed);

  @override
  String toString() => '$aperture - $shutterSpeed';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ExposurePair &&
        other.aperture == aperture &&
        other.shutterSpeed == shutterSpeed;
  }

  @override
  int get hashCode => Object.hash(aperture, shutterSpeed, runtimeType);
}
