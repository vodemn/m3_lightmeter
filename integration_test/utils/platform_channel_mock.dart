import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:light_sensor/light_sensor.dart';
import 'package:lightmeter/data/camera_info_service.dart';

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

void mockCameraFocalLength() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    CameraInfoService.cameraInfoPlatformChannel,
    (methodCall) async {
      switch (methodCall.method) {
        case "mainCameraEfl":
          return Platform.isAndroid
              ? 24.0 // Pixel 6
              : 26.0; // iPhone 13 Pro
        default:
          return null;
      }
    },
  );
}

void resetCameraFocalLength() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    CameraInfoService.cameraInfoPlatformChannel,
    null,
  );
}
