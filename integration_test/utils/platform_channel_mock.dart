import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _systemFeatureMethodChannel = MethodChannel('system_feature');
const _lightSensorMethodChannel = MethodChannel("light.eventChannel");

void setLightSensorAvilability({required bool hasSensor}) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    _systemFeatureMethodChannel,
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
    _systemFeatureMethodChannel,
    null,
  );
}

Future<void> sendMockIncidentEv(double ev) => sendMockLux((2.5 * pow(2, ev)).toInt());

Future<void> sendMockLux([int lux = 100]) async {
  await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
    _lightSensorMethodChannel.name,
    const StandardMethodCodec().encodeSuccessEnvelope(lux),
    (ByteData? data) {},
  );
}

void setupLightSensorStreamHandler() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    _lightSensorMethodChannel,
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
    _lightSensorMethodChannel,
    null,
  );
}
