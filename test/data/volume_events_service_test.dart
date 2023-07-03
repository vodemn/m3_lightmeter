import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/volume_events_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
    service = const VolumeEventsService();
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
    test('true', () async => expectLater(service.setVolumeHandling(true), completion(true)));

    test('false', () async => expectLater(service.setVolumeHandling(false), completion(false)));
  });

  group('volumeButtonsEventStream', () {
    test('true', () async => expectLater(service.setVolumeHandling(true), completion(true)));

    test('false', () async => expectLater(service.setVolumeHandling(false), completion(false)));
  });
}
