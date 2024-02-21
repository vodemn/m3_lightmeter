import 'package:lightmeter/data/models/camera_feature.dart';
import 'package:test/test.dart';

void main() {
  group(
    'fromJson()',
    () {
      test('All keys', () {
        expect(
          CameraFeaturesConfigJson.fromJson(
            {
              'spotMetering': true,
              'histogram': true,
            },
          ),
          {
            CameraFeature.spotMetering: true,
            CameraFeature.histogram: true,
          },
        );
      });

      test('Legacy (no spotMetering & histogram)', () {
        expect(
          CameraFeaturesConfigJson.fromJson({}),
          {
            CameraFeature.spotMetering: false,
            CameraFeature.histogram: false,
          },
        );
      });
    },
  );

  test('toJson()', () {
    expect(
      {
        CameraFeature.spotMetering: true,
        CameraFeature.histogram: true,
      }.toJson(),
      {
        'spotMetering': true,
        'histogram': true,
      },
    );
  });
}
