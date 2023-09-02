// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lightmeter/screens/metering/components/camera_container/models/camera_error_type.dart';
import 'package:lightmeter/screens/metering/components/camera_container/state_container_camera.dart';
import 'package:test/test.dart';

void main() {
  group(
    '`CameraActiveState`',
    () {
      final a = CameraActiveState(
        zoomRange: RangeValues(1, 7),
        currentZoom: 1,
        exposureOffsetRange: RangeValues(-4, 4),
        currentExposureOffset: 0,
        exposureOffsetStep: 0.167,
      );
      final b = CameraActiveState(
        zoomRange: RangeValues(1, 7),
        currentZoom: 1,
        exposureOffsetRange: RangeValues(-4, 4),
        currentExposureOffset: 0,
        exposureOffsetStep: 0.167,
      );
      final c = CameraActiveState(
        zoomRange: RangeValues(1, 4),
        currentZoom: 3,
        exposureOffsetRange: RangeValues(-2, 2),
        currentExposureOffset: 0,
        exposureOffsetStep: 0.167,
      );
      test('==', () {
        expect(a == b && b == a, true);
        expect(a != c && c != a, true);
        expect(b != c && c != b, true);
      });
      test('hashCode', () {
        expect(a.hashCode == b.hashCode, true);
        expect(a.hashCode != c.hashCode, true);
        expect(b.hashCode != c.hashCode, true);
      });
    },
  );

  group(
    '`CameraErrorState`',
    () {
      final a = CameraErrorState(CameraErrorType.noCamerasDetected);
      final b = CameraErrorState(CameraErrorType.noCamerasDetected);
      final c = CameraErrorState(CameraErrorType.other);
      test('==', () {
        expect(a == b && b == a, true);
        expect(a != c && c != a, true);
        expect(b != c && c != b, true);
      });
      test('hashCode', () {
        expect(a.hashCode == b.hashCode, true);
        expect(a.hashCode != c.hashCode, true);
        expect(b.hashCode != c.hashCode, true);
      });
    },
  );
}
