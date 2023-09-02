import 'package:flutter/services.dart';

class CaffeineService {
  static const _methodChannel = MethodChannel("com.vodemn.lightmeter/keepScreenOn");

  const CaffeineService();

  Future<bool> isKeepScreenOn() async {
    return _methodChannel.invokeMethod<bool>("isKeepScreenOn").then((value) => value!);
  }

  Future<bool> keepScreenOn(bool keep) async {
    return _methodChannel.invokeMethod<bool>("setKeepScreenOn", keep).then((value) => value!);
  }
}
