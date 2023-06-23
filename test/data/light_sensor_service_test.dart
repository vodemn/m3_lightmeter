import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/light_sensor_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LightSensorService service;

  const methodChannel = MethodChannel('system_feature');
  // TODO: add event channel mock
  //const eventChannel = EventChannel('light.eventChannel');

  setUp(() {
    service = const LightSensorService();
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, null);
  });

  group(
    'hasSensor()',
    () {
      test('true', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(methodChannel, null);
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(methodChannel, (methodCall) async {
          switch (methodCall.method) {
            case "sensor":
              return true;
            default:
              return null;
          }
        });
        expectLater(service.hasSensor(), completion(true));
      });

      test('false', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(methodChannel, null);
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(methodChannel, (methodCall) async {
          switch (methodCall.method) {
            case "sensor":
              return false;
            default:
              return null;
          }
        });
        expectLater(service.hasSensor(), completion(false));
      });
      test('null', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(methodChannel, null);
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(methodChannel, (methodCall) async {
          switch (methodCall.method) {
            case "sensor":
              return null;
            default:
              return null;
          }
        });
        expectLater(service.hasSensor(), completion(false));
      });
    },
  );
}
