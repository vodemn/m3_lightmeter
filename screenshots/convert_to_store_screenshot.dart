import 'dart:io';

import 'package:image/image.dart';

import 'models/screenshot_args.dart';
import 'models/screenshot_device.dart';
import 'models/screenshot_layout.dart';
import 'utils/parse_configs.dart';

final _configs = parseScreenshotConfigs();

extension ScreenshotImage on Image {
  Image convertToStoreScreenshot({
    required ScreenshotArgs args,
    required ScreenshotLayout layout,
  }) {
    if (_configs[args.name] == null) {
      return this;
    }
    print(args.deviceName);
    return _addSystemOverlay(
      screenshotDevices[args.deviceName]!,
      isDark: args.isDark,
    )
        ._addDeviceFrame(
          screenshotDevices[args.deviceName]!,
          ColorRgba8(
            args.backgroundColor.r,
            args.backgroundColor.g,
            args.backgroundColor.b,
            args.backgroundColor.a,
          ),
        )
        ._applyLayout(layout)
        ._addText(
          layout,
          _configs[args.name]!.title,
          _configs[args.name]!.subtitle,
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

  Image _addDeviceFrame(ScreenshotDevice device, Color backgroundColor) {
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

  Image _applyLayout(ScreenshotLayout layout) {
    final scaledScreenshot = copyResize(
      this,
      width: layout.size.width - (layout.contentPadding.left + layout.contentPadding.right),
    );

    return copyExpandCanvas(
      copyExpandCanvas(
        scaledScreenshot,
        newWidth: scaledScreenshot.width + layout.contentPadding.right,
        newHeight: scaledScreenshot.height + layout.contentPadding.bottom,
        position: ExpandCanvasPosition.topLeft,
        backgroundColor: getPixel(0, 0),
      ),
      newWidth: layout.size.width,
      newHeight: layout.size.height,
      position: ExpandCanvasPosition.bottomRight,
      backgroundColor: getPixel(0, 0),
    );
  }

  Image _addText(ScreenshotLayout layout, String title, String subtitle) {
    final titleFont = BitmapFont.fromZip(File(layout.titleFontPath).readAsBytesSync());
    final subtitleFont = BitmapFont.fromZip(File(layout.subtitleFontPath).readAsBytesSync());
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

    return compositeImage(
      this,
      textImage,
      dstX: layout.contentPadding.left,
      dstY: layout.contentPadding.top,
    );
  }
}
