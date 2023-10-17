import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> sendMockLux([int lux = 100]) async {
  await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
    "light.eventChannel",
    const StandardMethodCodec().encodeSuccessEnvelope(lux),
    (ByteData? data) {},
  );
}

Future<void> sendMockIncidentEv(double ev) async {
  await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
    "light.eventChannel",
    const StandardMethodCodec().encodeSuccessEnvelope((2.5 * pow(2, ev)).toInt()),
    (ByteData? data) {},
  );
}

void setLightSensorAvilability({required bool hasSensor}) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('system_feature'),
    (methodCall) async {
      switch (methodCall.method) {
        case "sensor":
          return hasSensor;
        default:
          return null;
      }
    },
  );
}
