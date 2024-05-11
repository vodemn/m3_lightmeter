import 'dart:convert';

class ScreenshotConfig {
  final String title;
  final String subtitle;
  final String screenshotPath;

  const ScreenshotConfig({
    required this.title,
    required this.subtitle,
    required this.screenshotPath,
  });
}

enum ScreenshotLayout {
  iphone65inch(
    size: (width: 1242, height: 2688),
    contentPadding: (left: 150, top: 192, right: 150, bottom: 192),
  ),
  iphone55inch(
    size: (width: 1242, height: 2208),
    contentPadding: (left: 150, top: 192, right: 150, bottom: 192),
  );

  final ({int height, int width}) size;
  final ({int left, int top, int right, int bottom}) contentPadding;

  const ScreenshotLayout({
    required this.size,
    required this.contentPadding,
  });
}
