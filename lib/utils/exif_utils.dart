import 'dart:math' as math;

import 'package:exif/exif.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

const String _isoExifKey = 'EXIF ISOSpeedRatings';
const String _apertureExifKey = 'EXIF FNumber';
const String _shutterSpeedExifKey = 'EXIF ExposureTime';

double evFromTags(Map<String, IfdTag> tags) {
  final iso = double.tryParse("${tags[_isoExifKey]}");
  final apertureValueRatio = (tags[_apertureExifKey]?.values as IfdRatios?)?.ratios.first;
  final speedValueRatio = (tags[_shutterSpeedExifKey]?.values as IfdRatios?)?.ratios.first;

  if (iso == null || apertureValueRatio == null || speedValueRatio == null) {
    throw ArgumentError(
      'Error calculating EV',
      [
        if (iso == null) '$_isoExifKey: ${tags[_isoExifKey]?.printable} ${tags[_isoExifKey]?.printable.runtimeType}',
        if (apertureValueRatio == null) '$_apertureExifKey: $apertureValueRatio',
        if (speedValueRatio == null) '$_shutterSpeedExifKey: $speedValueRatio',
      ].join(', '),
    );
  }

  final aperture = apertureValueRatio.toDouble();
  final speed = speedValueRatio.toDouble();

  return log2(math.pow(aperture, 2)) - log2(speed) - log2(iso / 100);
}
