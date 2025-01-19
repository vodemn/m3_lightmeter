import 'dart:math' as math;

import 'package:exif/exif.dart';
import 'package:flutter/foundation.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

const String _isoExifKey = 'EXIF ISOSpeedRatings';
const String _apertureExifKey = 'EXIF FNumber';
const String _shutterSpeedExifKey = 'EXIF ExposureTime';

Future<double> evFromImage(Uint8List bytes) async {
  final tags = await readExifFromBytes(bytes);
  final iso = double.tryParse("${tags[_isoExifKey]}");
  final apertureValueRatio = (tags[_apertureExifKey]?.values as IfdRatios?)?.ratios.first;
  final speedValueRatio = (tags[_shutterSpeedExifKey]?.values as IfdRatios?)?.ratios.first;
  
  if (iso == null || apertureValueRatio == null || speedValueRatio == null) {
    throw ArgumentError(
      'Error parsing EXIF',
      [
        if (iso == null) '$_isoExifKey: "${tags[_isoExifKey]?.printable}"',
        if (apertureValueRatio == null) '$_apertureExifKey: $apertureValueRatio',
        if (speedValueRatio == null) '$_shutterSpeedExifKey: $speedValueRatio',
      ].join(', '),
    );
  }

  final aperture = apertureValueRatio.toDouble();
  final speed = speedValueRatio.toDouble();

  return log2(math.pow(aperture, 2)) - log2(speed) - log2(iso / 100);
}
