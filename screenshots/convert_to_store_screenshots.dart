import 'dart:io';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:image/image.dart';
import 'package:logging/logging.dart';

import 'models/screenshot_args.dart';
import 'models/screenshot_device.dart';
import 'models/screenshot_layout.dart';
import 'utils/parse_configs.dart';

final _configs = parseScreenshotConfigs();

Future<int> main(List<String> args) async {
  final parser = ArgParser()
    ..addFlag('verbose', abbr: 'v', help: 'Verbose output')
    ..addOption('platform', abbr: 'p', help: 'Device platform', mandatory: true)
    ..addOption('device', abbr: 'd', help: 'device_snake_name', mandatory: true)
    ..addOption('layout', abbr: 'l', help: 'Device layout', mandatory: true);
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

    final file = await File(screenshotArgs.toPath(layout.name)).create(recursive: true);
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

extension ScreenshotImage on Image {
  Image convertToStoreScreenshot({
    required ScreenshotArgs args,
    required ScreenshotLayout layout,
  }) {
    if (_configs[args.nameWithTheme] == null) {
      return this;
    }
    return _addSystemOverlay(
      screenshotDevices[args.deviceName]!,
      isDark: args.isDark,
    )
        ._addDeviceFrame(
          screenshotDevices[args.deviceName]!,
          args.backgroundColor,
        )
        ._applyLayout(
          layout,
          _configs[args.nameWithTheme]!.title,
          _configs[args.nameWithTheme]!.subtitle,
          isDark: args.isDark,
        );
  }

  Image _addSystemOverlay(ScreenshotDevice device, {required bool isDark}) {
    final path = isDark ? device.systemOverlayPathDark : device.systemOverlayPathLight;
    final statusBar = copyResize(
      decodePng(File(path).readAsBytesSync())!,
      width: width,
    );
    return compositeImage(this, statusBar);
  }

  Image _addDeviceFrame(ScreenshotDevice device, String color) {
    final backgroundColor = ColorRgba8(
      int.parse(color.substring(2, 4), radix: 16),
      int.parse(color.substring(4, 6), radix: 16),
      int.parse(color.substring(6, 8), radix: 16),
      int.parse(color.substring(0, 2), radix: 16),
    );
    final screenshotRounded = copyCrop(
      this,
      x: 0,
      y: 0,
      width: width,
      height: height,
    );

    final frame = decodePng(File(device.deviceFramePath).readAsBytesSync())!;
    final expandedScreenshot = copyExpandCanvas(
      copyExpandCanvas(
        screenshotRounded,
        newWidth: screenshotRounded.width + device.screenshotFrameOffset.dx,
        newHeight: screenshotRounded.height + device.screenshotFrameOffset.dy,
        position: ExpandCanvasPosition.bottomRight,
        backgroundColor: backgroundColor,
      ),
      newWidth: frame.width,
      newHeight: frame.height,
      position: ExpandCanvasPosition.topLeft,
      backgroundColor: backgroundColor,
    );

    return compositeImage(expandedScreenshot, frame);
  }

  Image _applyLayout(ScreenshotLayout layout, String title, String subtitle, {required bool isDark}) {
    final textImage = _drawTitles(layout, title, subtitle, isDark: isDark);
    final maxFrameHeight =
        layout.size.height - (layout.contentPadding.top + textImage.height + 84 + layout.contentPadding.bottom);
    int maxFrameWidth = layout.size.width - (layout.contentPadding.left + layout.contentPadding.right);
    if (maxFrameWidth * height / width > maxFrameHeight) {
      maxFrameWidth = maxFrameHeight * width ~/ height;
    }
    final scaledScreenshot = copyResize(this, width: maxFrameWidth);

    final draft = copyExpandCanvas(
      copyExpandCanvas(
        scaledScreenshot,
        newWidth: scaledScreenshot.width + (layout.size.width - scaledScreenshot.width) ~/ 2,
        newHeight: scaledScreenshot.height + layout.contentPadding.bottom,
        position: ExpandCanvasPosition.topLeft,
        backgroundColor: getPixel(0, 0),
      ),
      newWidth: layout.size.width,
      newHeight: layout.size.height,
      position: ExpandCanvasPosition.bottomRight,
      backgroundColor: getPixel(0, 0),
    );

    return compositeImage(
      draft,
      textImage,
      dstX: layout.contentPadding.left,
      dstY: layout.contentPadding.top,
    );
  }

  Image _drawTitles(ScreenshotLayout layout, String title, String subtitle, {required bool isDark}) {
    final titleFont =
        BitmapFont.fromZip(File(isDark ? layout.titleFontDarkPath : layout.titleFontPath).readAsBytesSync());
    final subtitleFont =
        BitmapFont.fromZip(File(isDark ? layout.subtitleFontDarkPath : layout.subtitleFontPath).readAsBytesSync());
    final textImage = fill(
      Image(
        height: titleFont.lineHeight + 36 + subtitleFont.lineHeight * 2,
        width: layout.size.width - (layout.contentPadding.left + layout.contentPadding.right),
      ),
      color: getPixel(0, 0),
    );

    drawString(
      textImage,
      title,
      font: titleFont,
      y: 0,
    );

    int subtitleDy = titleFont.lineHeight + 36;
    subtitle.split('\n').forEach((line) {
      drawString(
        textImage,
        line,
        font: subtitleFont,
        y: subtitleDy,
      );
      subtitleDy += subtitleFont.lineHeight;
    });

    return textImage;
  }
}
