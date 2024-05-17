enum ScreenshotLayout {
  android(
    size: (width: 1440, height: 2560),
    contentPadding: (left: 144, top: 132, right: 144, bottom: 132),
    titleFontPath: 'screenshots/assets/fonts/SF-Pro-Display-Bold.zip',
    subtitleFontPath: 'screenshots/assets/fonts/SF-Pro-Display-Regular.zip',
  ),
  iphone65inch(
    size: (width: 1242, height: 2688),
    contentPadding: (left: 144, top: 184, right: 144, bottom: 184),
    titleFontPath: 'screenshots/assets/fonts/SF-Pro-Display-Bold.zip',
    subtitleFontPath: 'screenshots/assets/fonts/SF-Pro-Display-Regular.zip',
  ),
  iphone55inch(
    size: (width: 1242, height: 2208),
    contentPadding: (left: 144, top: 144, right: 144, bottom: 144),
    titleFontPath: 'screenshots/assets/fonts/SF-Pro-Display-Bold.zip',
    subtitleFontPath: 'screenshots/assets/fonts/SF-Pro-Display-Regular.zip',
  );

  final ({int height, int width}) size;
  final ({int left, int top, int right, int bottom}) contentPadding;
  final String titleFontPath;
  final String subtitleFontPath;

  String get titleFontDarkPath => '${titleFontPath.split('.').first}-dark.zip';
  String get subtitleFontDarkPath => '${subtitleFontPath.split('.').first}-dark.zip';

  const ScreenshotLayout({
    required this.size,
    required this.contentPadding,
    required this.titleFontPath,
    required this.subtitleFontPath,
  });
}
