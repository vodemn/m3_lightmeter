import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:test/test.dart';

void main() {
  test('fromJson', () {
    expect(
      MeteringScreenLayoutConfigJson.fromJson({'0': true, '1': true}),
      {
        MeteringScreenLayoutFeature.extremeExposurePairs: true,
        MeteringScreenLayoutFeature.filmPicker: true,
      },
    );
    expect(
      MeteringScreenLayoutConfigJson.fromJson({'0': false, '1': false}),
      {
        MeteringScreenLayoutFeature.extremeExposurePairs: false,
        MeteringScreenLayoutFeature.filmPicker: false,
      },
    );
  });

  test('toJson', () {
    expect(
      {
        MeteringScreenLayoutFeature.extremeExposurePairs: true,
        MeteringScreenLayoutFeature.filmPicker: true,
      }.toJson(),
      {'0': true, '1': true},
    );
  });
}
