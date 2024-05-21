class ScreenshotConfig {
  final String title;
  final String subtitle;
  final String screenshotName;

  const ScreenshotConfig({
    required this.title,
    required this.subtitle,
    required this.screenshotName,
  });

  factory ScreenshotConfig.fromJson(Map<String, dynamic> data) {
    return ScreenshotConfig(
      title: data['title'] as String,
      subtitle: data['subtitle'] as String,
      screenshotName: data['screenshotName'] as String,
    );
  }
}
