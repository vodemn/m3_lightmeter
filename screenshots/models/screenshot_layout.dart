enum ScreenshotLayout {
  iphone65inch(
    size: (width: 1242, height: 2688),
    contentPadding: (left: 150, top: 192, right: 150, bottom: 192),
    titleFontPath: 'screenshots/assets/fonts/SF-Pro-Display-Bold.zip',
    subtitleFontPath: 'screenshots/assets/fonts/SF-Pro-Display-Regular.zip',
  ),
  iphone55inch(
    size: (width: 1242, height: 2208),
    contentPadding: (left: 150, top: 192, right: 150, bottom: 192),
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
