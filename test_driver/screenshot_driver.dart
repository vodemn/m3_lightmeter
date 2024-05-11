import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:integration_test/integration_test_driver_extended.dart';

import '../screenshots/devices_config.dart';
import '../screenshots/screenshot_args.dart';
import '../screenshots/screenshot_config.dart';
import 'utils/grant_camera_permission.dart';

Future<void> main() async {
  await grantCameraPermission();
  await integrationDriver(
    onScreenshot: (name, bytes, [_]) async {
      final screenshotArgs = ScreenshotArgs.fromString(name);
      final backgroundColor = ColorRgba8(
        screenshotArgs.backgroundColor.r,
        screenshotArgs.backgroundColor.g,
        screenshotArgs.backgroundColor.b,
        screenshotArgs.backgroundColor.a,
      );
      final platform =
          screenshotArgs.platformFolder == 'ios' ? ScreenshotDevicePlatform.ios : ScreenshotDevicePlatform.ios;
      final deviceName = screenshotArgs.deviceName;
      final file = await File(screenshotArgs.toPath()).create(recursive: true);

      // switch (platform) {
      //   case ScreenshotDevicePlatform.ios:
      //     final device = screenshotDevicesIos.firstWhere(
      //       (device) => device.name == deviceName,
      //       orElse: () => ScreenshotDevice(name: '', platform: platform),
      //     );
      //     Image screenshot = decodePng(Uint8List.fromList(bytes))!;
      //     screenshot = screenshot.addSystemOverlay(device, isDark: screenshotArgs.isDark);
      //     screenshot = screenshot.addDeviceFrame(device, backgroundColor);
      //     file.writeAsBytesSync(encodePng(screenshot));
      //   case ScreenshotDevicePlatform.android:
      //     file.writeAsBytesSync(bytes);
      // }

      file.writeAsBytesSync(bytes);
      return true;
    },
  );
}

extension ScreenshotImage on Image {
  Image addSystemOverlay(ScreenshotDevice device, {required bool isDark}) {
    final path = isDark ? device.systemOverlayPathDark : device.systemOverlayPathLight;
    final statusBar = copyResize(
      decodePng(File(path).readAsBytesSync())!,
      width: width,
    );
    return compositeImage(this, statusBar);
  }

  Image addDeviceFrame(ScreenshotDevice device, Color backgroundColor) {
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

  Image applyLayout(ScreenshotLayout layout) {
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
}
