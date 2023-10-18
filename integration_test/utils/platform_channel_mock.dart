import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

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

void resetLightSensorAvilability() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('system_feature'),
    null,
  );
}

Future<void> sendMockIncidentEv(double ev) => sendMockLux((2.5 * pow(2, ev)).toInt());

Future<void> sendMockLux([int lux = 100]) async {
  await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
    "light.eventChannel",
    const StandardMethodCodec().encodeSuccessEnvelope(lux),
    (ByteData? data) {},
  );
}

void setupLightSensorStreamHandler() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('light.eventChannel'),
    (methodCall) async {
      switch (methodCall.method) {
        case "listen":
          return;
        case "cancel":
          return;
        default:
          return null;
      }
    },
  );
}

void resetLightSensorStreamHandler() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('light.eventChannel'),
    null,
  );
}
