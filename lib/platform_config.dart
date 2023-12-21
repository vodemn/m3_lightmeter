class PlatformConfig {
  const PlatformConfig._();

  static double get cameraPreviewAspectRatio {
    final rational = const String.fromEnvironment('cameraPreviewAspectRatio').split('/');
    return int.parse(rational[0]) / int.parse(rational[1]);
  }

  static String get cameraStubImage => const String.fromEnvironment('cameraStubImage');

  static bool get isTest => cameraStubImage.isNotEmpty;
}
