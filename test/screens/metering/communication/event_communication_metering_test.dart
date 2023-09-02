// ignore_for_file: prefer_const_constructors

import 'package:lightmeter/screens/metering/communication/event_communication_metering.dart';
import 'package:test/test.dart';

void main() {
  group(
    '`MeteringInProgressEvent`',
    () {
      final a = MeteringInProgressEvent(1.0);
      final b = MeteringInProgressEvent(1.0);
      final c = MeteringInProgressEvent(2.0);
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
    '`MeteringEndedEvent`',
    () {
      final a = MeteringEndedEvent(1.0);
      final b = MeteringEndedEvent(1.0);
      final c = MeteringEndedEvent(2.0);
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
