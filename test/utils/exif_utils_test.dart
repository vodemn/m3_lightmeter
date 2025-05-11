import 'dart:io';

import 'package:exif/exif.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/utils/exif_utils.dart';

void main() {
  group('evFromTags', () {
    test(
      'camera_stub_image.jpg',
      () async {
        final bytes = File('assets/camera_stub_image.jpg').readAsBytesSync();
        final tags = await readExifFromBytes(bytes);
        expect(evFromTags(tags), 8.25230310752341);
      },
    );

    test(
      'no EXIF',
      () async {
        final bytes = File('assets/launcher_icon_dev_512.png').readAsBytesSync();
        final tags = await readExifFromBytes(bytes);
        expect(() => evFromTags(tags), throwsArgumentError);
      },
    );
  });
}
