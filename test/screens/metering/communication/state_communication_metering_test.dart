// ignore_for_file: prefer_const_constructors

import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart';
import 'package:test/test.dart';

void main() {
  group(
    '`MeteringInProgressState`',
    () {
      final a = MeteringInProgressState(1.0);
      final b = MeteringInProgressState(1.0);
      final c = MeteringInProgressState(2.0);
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
    '`MeteringEndedState`',
    () {
      final a = MeteringEndedState(1.0);
      final b = MeteringEndedState(1.0);
      final c = MeteringEndedState(2.0);
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
