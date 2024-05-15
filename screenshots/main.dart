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
    ..addOption('device', abbr: 'd', help: 'device_snake_name', mandatory: true)
    ..addOption('layout', abbr: 'l', help: 'Device platform.', mandatory: true);
  final ArgResults argResults = parser.parse(args);

  if (argResults['verbose'] as bool) {
    Logger.root.level = Level.ALL;
  } else {
    Logger.root.level = Level.INFO;
  }

  final platform = argResults["platform"] as String;
  final device = argResults["device"] as String;
  final layout = ScreenshotLayout.values.firstWhere((e) => e.name == argResults["layout"] as String);

  Directory('screenshots/generated/raw/$platform/$device').listSync().forEach((filePath) async {
    final screenshotName = filePath.path.split('/').last.replaceAll('.png', '');
    final screenshotBytes = File(filePath.path).readAsBytesSync();
    final screenshot = decodePng(Uint8List.fromList(screenshotBytes))!;

    final screenshotArgs = ScreenshotArgs.fromRawName(
      name: screenshotName,
      deviceName: device,
      platformFolder: platform,
    );

    final file =
        await File('screenshots/generated/$platform/${layout.name}/${screenshotArgs.name}.png').create(recursive: true);
    file.writeAsBytesSync(
      encodePng(
        screenshot.convertToStoreScreenshot(
          args: screenshotArgs,
          layout: layout,
        ),
      ),
    );
  });

  return 0;
}
