import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform/platform.dart';

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
      VolumeEventsService.volumeHandlingChannel,
      methodCallSuccessHandler,
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      VolumeEventsService.volumeHandlingChannel,
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
    // test('Android', () async {
    //   when(() => localPlatform.isAndroid).thenReturn(true);
    //   expect(service.volumeButtonsEventStream(), const Stream.empty());
    // });

    test('iOS', () async {
      when(() => localPlatform.isAndroid).thenReturn(false);
      expect(service.volumeButtonsEventStream(), const Stream<int>.empty());
    });
  });
}
