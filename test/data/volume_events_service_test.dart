import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform/platform.dart';

import '../event_channel_mock.dart';

class _MockLocalPlatform extends Mock implements LocalPlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockLocalPlatform localPlatform;
  late VolumeEventsService service;

  Future<Object?>? methodCallSuccessHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "setVolumeHandling":
        return methodCall.arguments as bool;
      default:
        throw UnimplementedError();
    }
  }

  setUp(() {
    localPlatform = _MockLocalPlatform();
    service = VolumeEventsService(localPlatform);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      VolumeEventsService.volumeMethodChannel,
      methodCallSuccessHandler,
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      VolumeEventsService.volumeMethodChannel,
      null,
    );
  });

  group('setVolumeHandling', () {
    test('true - Android', () async {
      when(() => localPlatform.isAndroid).thenReturn(true);
      expectLater(service.setVolumeHandling(true), completion(true));
    });

    test('true - iOS', () async {
      when(() => localPlatform.isAndroid).thenReturn(false);
      expectLater(service.setVolumeHandling(true), completion(false));
    });

    test('false - Android', () async {
      when(() => localPlatform.isAndroid).thenReturn(true);
      expectLater(service.setVolumeHandling(false), completion(false));
    });

    test('false - iOS', () async {
      when(() => localPlatform.isAndroid).thenReturn(false);
      expectLater(service.setVolumeHandling(false), completion(false));
    });
  });

  group('volumeButtonsEventStream', () {
    test('Android', () async {
      when(() => localPlatform.isAndroid).thenReturn(true);
      final stream = service.volumeButtonsEventStream();
      final List<int> result = [];
      final subscription = stream.listen(result.add);
      await sendMockVolumeAction(VolumeEventsService.volumeEventsChannel.name, 24);
      await sendMockVolumeAction(VolumeEventsService.volumeEventsChannel.name, 25);
      await sendMockVolumeAction(VolumeEventsService.volumeEventsChannel.name, 20);
      await sendMockVolumeAction(VolumeEventsService.volumeEventsChannel.name, 24);
      expect(result, [24, 25, 24]);
      subscription.cancel();
    });

    test('iOS', () async {
      when(() => localPlatform.isAndroid).thenReturn(false);
      expect(service.volumeButtonsEventStream(), const Stream<int>.empty());
    });
  });
}
