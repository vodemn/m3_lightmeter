enum ScreenshotDevicePlatform { android, ios }

class ScreenshotDevice {
  final String name;
  final ScreenshotDevicePlatform platform;

  const ScreenshotDevice({
    required this.name,
    required this.platform,
  });

  ScreenshotDevice.fromDisplayName({
    required String displayName,
    required this.platform,
  }) : name = displayName.replaceAll(' ', '_').toLowerCase();

  String get systemOverlayPathLight =>
      'screenshots/assets/system_overlays/${platform.name}/${name}_system_overlay_light.png';
  String get systemOverlayPathDark =>
      'screenshots/assets/system_overlays/${platform.name}/${name}_system_overlay_dark.png';
}

final screenshotDevicesIos = [
  ScreenshotDevice.fromDisplayName(displayName: 'iPhone 8 Plus', platform: ScreenshotDevicePlatform.ios),
  ScreenshotDevice.fromDisplayName(displayName: 'iPhone 13 Pro', platform: ScreenshotDevicePlatform.ios),
];
