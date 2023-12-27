import 'dart:io';

class PlatformConfig {
  const PlatformConfig._();

  static double get cameraPreviewAspectRatio => Platform.isAndroid ? 240 / 320 : 288 / 352;

  static String get cameraStubImage => const String.fromEnvironment('cameraStubImage');

  static bool get isTest => cameraStubImage.isNotEmpty;
}
