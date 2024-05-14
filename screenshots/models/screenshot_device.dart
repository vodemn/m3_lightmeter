enum ScreenshotDevicePlatform { android, ios }

class ScreenshotDevice {
  final String name;
  final ScreenshotDevicePlatform platform;
  final ({int dx, int dy}) screenshotFrameOffset;

  const ScreenshotDevice({
    required this.name,
    required this.platform,
    this.screenshotFrameOffset = (dx: 0, dy: 0),
  });

  ScreenshotDevice.fromDisplayName({
    required String displayName,
    required this.platform,
    this.screenshotFrameOffset = (dx: 0, dy: 0),
  }) : name = displayName.replaceAll(' ', '_').toLowerCase();

  String get systemOverlayPathLight =>
      'screenshots/assets/system_overlays/${platform.name}/${name}_system_overlay_light.png';
  String get systemOverlayPathDark =>
      'screenshots/assets/system_overlays/${platform.name}/${name}_system_overlay_dark.png';
  String get deviceFramePath => 'screenshots/assets/frames/${platform.name}/${name}_frame.png';
}

final screenshotDevices = <String, ScreenshotDevice>{for (final d in _screenshotDevicesIos) d.name: d};
final List<ScreenshotDevice> _screenshotDevicesIos = [
  ScreenshotDevice.fromDisplayName(
    displayName: 'iPhone 8 Plus',
    platform: ScreenshotDevicePlatform.ios,
  ),
  ScreenshotDevice.fromDisplayName(
    displayName: 'iPhone 13 Pro',
    platform: ScreenshotDevicePlatform.ios,
    screenshotFrameOffset: (dx: 72, dy: 60),
  ),
];
