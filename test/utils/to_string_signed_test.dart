import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/utils/to_string_signed.dart';

void main() {
  test('toStringSignedAsFixed(0)', () {
    expect(1.5.toStringSignedAsFixed(0), '+2');
    expect((-1.5).toStringSignedAsFixed(0), '-2');
    expect(0.0.toStringSignedAsFixed(0), '0');
  });

  test('toStringSignedAsFixed(1)', () {
    expect(1.5.toStringSignedAsFixed(1), '+1.5');
    expect((-1.5).toStringSignedAsFixed(1), '-1.5');
    expect(0.0.toStringSignedAsFixed(1), '0.0');
  });
}
