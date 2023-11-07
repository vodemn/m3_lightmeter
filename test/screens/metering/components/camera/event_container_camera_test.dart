// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:lightmeter/screens/metering/components/camera_container/event_container_camera.dart';
import 'package:test/test.dart';

void main() {
  group(
    '`ZoomChangedEvent`',
    () {
      final a = ZoomChangedEvent(1.0);
      final b = ZoomChangedEvent(1.0);
      final c = ZoomChangedEvent(2.0);
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
    '`ExposureOffsetChangedEvent`',
    () {
      final a = ExposureOffsetChangedEvent(1.0);
      final b = ExposureOffsetChangedEvent(1.0);
      final c = ExposureOffsetChangedEvent(2.0);
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
    '`ExposureSpotChangedEvent`',
    () {
      final a = ExposureSpotChangedEvent(Offset(0.0, 0.0));
      final b = ExposureSpotChangedEvent(Offset(0.0, 0.0));
      final c = ExposureSpotChangedEvent(Offset(2.0, 2.0));
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
