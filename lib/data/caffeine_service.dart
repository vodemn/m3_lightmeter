import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CaffeineService {
  @visibleForTesting
  static const caffeineMethodChannel = MethodChannel("com.vodemn.lightmeter.CaffeinePlatformChannel.MethodChannel");

  const CaffeineService();

  Future<bool> isKeepScreenOn() async {
    return caffeineMethodChannel.invokeMethod<bool>("isKeepScreenOn").then((value) => value!);
  }

  Future<bool> keepScreenOn(bool keep) async {
    return caffeineMethodChannel.invokeMethod<bool>("setKeepScreenOn", keep).then((value) => value!);
  }
}
