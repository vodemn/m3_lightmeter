import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

import '../screenshots/models/screenshot_args.dart';

Future<void> main() async {
  await integrationDriver(
    onScreenshot: (name, bytes, [_]) async {
      final screenshotArgs = ScreenshotArgs.fromString(name);
      final file = await File(screenshotArgs.toPathRaw()).create(recursive: true);
      file.writeAsBytesSync(bytes);
      return true;
    },
  );
}
