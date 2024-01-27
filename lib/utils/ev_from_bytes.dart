import 'dart:math' as math;
import 'dart:typed_data';

import 'package:exif/exif.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

Future<double> evFromImage(Uint8List bytes) async {
  final tags = await readExifFromBytes(bytes);
  final iso = double.tryParse("${tags["EXIF ISOSpeedRatings"]}");
  final apertureValueRatio = (tags["EXIF FNumber"]?.values as IfdRatios?)?.ratios.first;
  final speedValueRatio = (tags["EXIF ExposureTime"]?.values as IfdRatios?)?.ratios.first;
  if (iso == null || apertureValueRatio == null || speedValueRatio == null) {
    throw 'Error parsing EXIF: ${tags.keys}';
  }

  final aperture = apertureValueRatio.numerator / apertureValueRatio.denominator;
  final speed = speedValueRatio.numerator / speedValueRatio.denominator;

  return log2(math.pow(aperture, 2)) - log2(speed) - log2(iso / 100);
}
