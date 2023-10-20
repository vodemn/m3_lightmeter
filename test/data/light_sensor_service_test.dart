import 'package:flutter_test/flutter_test.dart';
import 'package:light_sensor/light_sensor.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform/platform.dart';

import '../event_channel_mock.dart';

class _MockLocalPlatform extends Mock implements LocalPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockLocalPlatform localPlatform;
  late LightSensorService service;

  setUp(() {
    localPlatform = _MockLocalPlatform();
    service = LightSensorService(localPlatform);
  });

  group(
    'hasSensor()',
    () {
      void setMockSensorAvailability({required bool hasSensor}) {
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

      tearDown(() {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
          LightSensor.methodChannel,
          null,
        );
      });

      test('true - Android', () async {
        when(() => localPlatform.isAndroid).thenReturn(true);
        setMockSensorAvailability(hasSensor: true);
        expectLater(service.hasSensor(), completion(true));
      });

      test('false - Android', () async {
        when(() => localPlatform.isAndroid).thenReturn(true);
        setMockSensorAvailability(hasSensor: false);
        expectLater(service.hasSensor(), completion(false));
      });

      test('false - iOS', () async {
        when(() => localPlatform.isAndroid).thenReturn(false);
        expectLater(service.hasSensor(), completion(false));
      });
    },
  );

  group('luxStream', () {
    test('Android', () async {
      when(() => localPlatform.isAndroid).thenReturn(true);
      final stream = service.luxStream();
      final List<int> result = [];
      final subscription = stream.listen(result.add);
      await sendMockVolumeAction(LightSensor.eventChannel.name, 100);
      await sendMockVolumeAction(LightSensor.eventChannel.name, 150);
      await sendMockVolumeAction(LightSensor.eventChannel.name, 150);
      await sendMockVolumeAction(LightSensor.eventChannel.name, 200);
      expect(result, [100, 150, 150, 200]);
      subscription.cancel();
    });

    test('iOS', () async {
      when(() => localPlatform.isAndroid).thenReturn(false);
      expect(service.luxStream(), const Stream<int>.empty());
    });
  });
}
