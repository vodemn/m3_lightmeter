import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/utils/ev_from_bytes.dart';

void main() {
  group('evFromImage', () {
    test(
      'camera_stub_image.jpg',
      () {
        final bytes = File('assets/camera_stub_image.jpg').readAsBytesSync();
        expectLater(evFromImage(bytes), completion(8.25230310752341));
      },
    );

    test(
      'no EXIF',
      () {
        final bytes = File('assets/launcher_icon_dev_512.png').readAsBytesSync();
        expectLater(evFromImage(bytes), throwsFlutterError);
      },
    );
  });
}
