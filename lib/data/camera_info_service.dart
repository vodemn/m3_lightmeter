import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CameraInfoService {
  @visibleForTesting
  static const cameraInfoPlatformChannel = MethodChannel("com.vodemn.lightmeter.CameraInfoPlatformChannel");

  const CameraInfoService();

  Future<int?> mainCameraEfl() async {
    if (Platform.isIOS) {
      return null;
    }
    return (await cameraInfoPlatformChannel.invokeMethod<double?>('mainCameraEfl'))?.round();
  }
}
