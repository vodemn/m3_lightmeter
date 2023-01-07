class PlatformConfig {
  static double get cameraPreviewAspectRatio {
    final rational = const String.fromEnvironment('cameraPreviewAspectRatio', defaultValue: "3/4").split('/');
    return int.parse(rational[0]) / int.parse(rational[1]);
  }
}
