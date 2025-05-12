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
              'showFocalLength': true,
            },
          ),
          {
            CameraFeature.spotMetering: true,
            CameraFeature.histogram: true,
            CameraFeature.showFocalLength: true,
          },
        );
      });

      test('Legacy', () {
        expect(
          CameraFeaturesConfigJson.fromJson({}),
          {
            CameraFeature.spotMetering: true,
            CameraFeature.histogram: false,
            CameraFeature.showFocalLength: true,
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
        CameraFeature.showFocalLength: true,
      }.toJson(),
      {
        'spotMetering': true,
        'histogram': true,
        'showFocalLength': true,
      },
    );
  });
}
