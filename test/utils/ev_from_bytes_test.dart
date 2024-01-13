import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/utils/ev_from_bytes.dart';

void main() {
  test(
    'evFromImage',
    () {
      final bytes = File('assets/camera_stub_image.jpg').readAsBytesSync();
      expectLater(evFromImage(bytes), completion(8.25230310752341));
    },
  );
}
