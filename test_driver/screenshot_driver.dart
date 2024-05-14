import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:integration_test/integration_test_driver_extended.dart';

import '../screenshots/convert_to_store_screenshot.dart';
import '../screenshots/models/screenshot_args.dart';
import '../screenshots/models/screenshot_layout.dart';

Future<void> main() async {
  await integrationDriver(
    onScreenshot: (name, bytes, [_]) async {
      final screenshotArgs = ScreenshotArgs.fromString(name);
      final file = await File(screenshotArgs.toPathRaw()).create(recursive: true);
      final screenshot = decodePng(Uint8List.fromList(bytes))!.convertToStoreScreenshot(
        args: screenshotArgs,
        layout: ScreenshotLayout.iphone65inch,
      );

      file.writeAsBytesSync(encodePng(screenshot));
      return true;
    },
  );
}
