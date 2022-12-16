import 'package:lightmeter/data/models/aperture_value.dart';
import 'package:lightmeter/data/models/iso_value.dart';
import 'package:lightmeter/data/models/photography_value.dart';
import 'package:lightmeter/data/models/shutter_speed_value.dart';
import 'package:test/test.dart';

void main() {
  // Stringify
  test('Stringify aperture values', () {
    expect(apertureValues.first.toString(), "f/1.0");
    expect(apertureValues.last.toString(), "f/45");
  });

  test('Stringify iso values', () {
    expect(isoValues.first.toString(), "3");
    expect(isoValues.last.toString(), "6400");
  });

  test('Stringify shutter speed values', () {
    expect(shutterSpeedValues.first.toString(), "1/2000");
    expect(shutterSpeedValues.last.toString(), "16\"");
  });

  // Stops
  test('Aperture values stops lists', () {
    expect(apertureValues.fullStops().length, 12);
    expect(apertureValues.halfStops().length, 12 + 11);
    expect(apertureValues.thirdStops().length, 12 + 22);
  });

  test('Iso values stops lists', () {
    expect(isoValues.fullStops().length, 12);
    expect(isoValues.thirdStops().length, 12 + 22);
  });

  test('Shutter speed values stops lists', () {
    expect(shutterSpeedValues.fullStops().length, 16);
    expect(shutterSpeedValues.halfStops().length, 16 + 15);
    expect(shutterSpeedValues.thirdStops().length, 16 + 30);
  });
}
