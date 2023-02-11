import 'package:flutter/services.dart';

class CaffeineService {
  static const _methodChannel = MethodChannel("com.vodemn.lightmeter/keepScreenOn");

  const CaffeineService();

  Future<bool> isKeepScreenOn() async {
    return await _methodChannel.invokeMethod<bool>("isKeepScreenOn").then((value) => value!);
  }

  Future<void> keepScreenOn(bool keep) async {
    await _methodChannel.invokeMethod<bool>("setKeepScreenOn", keep);
  }
}
