import 'dart:io';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:image/image.dart';
import 'package:logging/logging.dart';

import 'convert_to_store_screenshot.dart';
import 'models/screenshot_args.dart';
import 'models/screenshot_layout.dart';

Future<int> main(List<String> args) async {
  final parser = ArgParser()
    ..addFlag('verbose', abbr: 'v', help: 'Verbose output.')
    ..addOption('platform', abbr: 'p', help: 'Device platform.', mandatory: true)
    ..addOption('device', abbr: 'd', help: 'device_snake_name', mandatory: true);
  final ArgResults argResults = parser.parse(args);

  if (argResults['verbose'] as bool) {
    Logger.root.level = Level.ALL;
  } else {
    Logger.root.level = Level.INFO;
  }

  final device = argResults["device"] as String;
  final platform = argResults["platform"] as String;
  Directory('screenshots/generated/raw/$platform/$device').listSync().forEach((filePath) async {
    final screenshotName = filePath.path.split('/').last.replaceAll('.png', '');
    final screenshotBytes = File(filePath.path).readAsBytesSync();
    final screenshot = decodePng(Uint8List.fromList(screenshotBytes))!;
    final topLeftPixel = screenshot.getPixel(0, 0);

    final screenshotArgs = ScreenshotArgs(
      name: screenshotName,
      deviceName: device,
      platformFolder: platform,
      backgroundColor: (
        r: topLeftPixel.r.toInt(),
        g: topLeftPixel.g.toInt(),
        b: topLeftPixel.b.toInt(),
        a: topLeftPixel.a.toInt(),
      ),
      isDark: filePath.path.contains('dark-'),
    );

    final file = await File(filePath.path.replaceAll('/raw', '')).create(recursive: true);
    file.writeAsBytesSync(
      encodePng(
        screenshot.convertToStoreScreenshot(
          args: screenshotArgs,
          layout: ScreenshotLayout.iphone65inch,
        ),
      ),
    );
  });

  return 0;
}
