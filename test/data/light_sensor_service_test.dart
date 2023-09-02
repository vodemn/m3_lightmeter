import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform/platform.dart';

class _MockLocalPlatform extends Mock implements LocalPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockLocalPlatform localPlatform;
  late LightSensorService service;

  const methodChannel = MethodChannel('system_feature');
  // TODO: add event channel mock
  //const eventChannel = EventChannel('light.eventChannel');

  setUp(() {
    localPlatform = _MockLocalPlatform();
    service = LightSensorService(localPlatform);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, null);
  });

  group(
    'hasSensor()',
    () {
      test('true - Android', () async {
        when(() => localPlatform.isAndroid).thenReturn(true);
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

      test('false - Android', () async {
        when(() => localPlatform.isAndroid).thenReturn(true);
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

      test('null - Android', () async {
        when(() => localPlatform.isAndroid).thenReturn(true);
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

      test('false - iOS', () async {
        when(() => localPlatform.isAndroid).thenReturn(false);
        expectLater(service.hasSensor(), completion(false));
      });
    },
  );

  group('luxStream', () {
    // test('Android', () async {
    //   when(() => localPlatform.isAndroid).thenReturn(true);
    //   expect(service.luxStream(), const Stream.empty());
    // });

    test('iOS', () async {
      when(() => localPlatform.isAndroid).thenReturn(false);
      expect(service.luxStream(), const Stream<int>.empty());
    });
  });
}
