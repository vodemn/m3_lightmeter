import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:lightmeter/data/analytics/analytics.dart';

class CameraInfoService {
  @visibleForTesting
  static const cameraInfoPlatformChannel = MethodChannel(
    "com.vodemn.lightmeter.CameraInfoPlatformChannel.MethodChannel",
  );

  final LightmeterAnalytics analytics;

  const CameraInfoService(this.analytics);

  Future<int?> mainCameraEfl() async {
    try {
      final focalLength = await cameraInfoPlatformChannel.invokeMethod<double?>('mainCameraEfl');
      return focalLength?.round();
    } on PlatformException catch (e) {
      analytics.logEvent(
        e.code,
        parameters: {
          "message": "${e.message}",
          "details": e.details.toString(),
        },
      );
      return null;
    } catch (e) {
      analytics.logEvent(e.toString());
      return null;
    }
  }
}
