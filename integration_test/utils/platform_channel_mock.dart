import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:light_sensor/light_sensor.dart';

void setLightSensorAvilability({required bool hasSensor}) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    LightSensor.methodChannel,
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
    LightSensor.methodChannel,
    null,
  );
}

Future<void> sendMockIncidentEv(double ev) => sendMockLux((2.5 * pow(2, ev)).toInt());

Future<void> sendMockLux([int lux = 100]) async {
  await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
    LightSensor.eventChannel.name,
    const StandardMethodCodec().encodeSuccessEnvelope(lux),
    (ByteData? data) {},
  );
}

void setupLightSensorStreamHandler() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    MethodChannel(LightSensor.eventChannel.name),
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
    MethodChannel(LightSensor.eventChannel.name),
    null,
  );
}
