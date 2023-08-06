import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:test/test.dart';

void main() {
  group(
    'fromJson()',
    () {
      test('All keys', () {
        expect(
          MeteringScreenLayoutConfigJson.fromJson(
            {
              '0': true,
              '1': true,
              '2': true,
            },
          ),
          {
            MeteringScreenLayoutFeature.extremeExposurePairs: true,
            MeteringScreenLayoutFeature.filmPicker: true,
            MeteringScreenLayoutFeature.histogram: true,
          },
        );
      });

      test('Legacy (no equipment profiles)', () {
        expect(
          MeteringScreenLayoutConfigJson.fromJson(
            {
              '0': true,
              '1': true,
            },
          ),
          {
            MeteringScreenLayoutFeature.extremeExposurePairs: true,
            MeteringScreenLayoutFeature.filmPicker: true,
            MeteringScreenLayoutFeature.histogram: true,
          },
        );
      });
    },
  );

  test('toJson', () {
    expect(
      {
        MeteringScreenLayoutFeature.extremeExposurePairs: true,
        MeteringScreenLayoutFeature.filmPicker: true,
        MeteringScreenLayoutFeature.histogram: true,
      }.toJson(),
      {
        '0': true,
        '1': true,
        '2': true,
      },
    );
  });
}
