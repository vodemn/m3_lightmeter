import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:test/test.dart';

void main() {
  test('toString()', () {
    expect(
      ExposurePair(ApertureValue.values.first, ShutterSpeedValue.values.first).toString(),
      '${ApertureValue.values.first} - ${ShutterSpeedValue.values.first}',
    );
  });

  test('==', () {
    expect(
      ExposurePair(ApertureValue.values.first, ShutterSpeedValue.values.first) ==
          ExposurePair(ApertureValue.values.first, ShutterSpeedValue.values.first),
      true,
    );
    expect(
      ExposurePair(ApertureValue.values.first, ShutterSpeedValue.values.first) ==
          ExposurePair(ApertureValue.values.first, ShutterSpeedValue.values.last),
      false,
    );
  });

  test('hashCode', () {
    expect(
      ExposurePair(ApertureValue.values.first, ShutterSpeedValue.values.first).hashCode ==
          ExposurePair(ApertureValue.values.first, ShutterSpeedValue.values.first).hashCode,
      true,
    );
    expect(
      ExposurePair(ApertureValue.values.first, ShutterSpeedValue.values.first).hashCode ==
          ExposurePair(ApertureValue.values.first, ShutterSpeedValue.values.last).hashCode,
      false,
    );
  });
}
