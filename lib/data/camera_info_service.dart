import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CameraInfoService {
  @visibleForTesting
  static const cameraInfoPlatformChannel = MethodChannel(
    "com.vodemn.lightmeter.CameraInfoPlatformChannel.MethodChannel",
  );

  const CameraInfoService();

  Future<int?> mainCameraEfl() async {
    final focalLength = await cameraInfoPlatformChannel.invokeMethod<double?>('mainCameraEfl');
    return focalLength?.round();
  }
}
