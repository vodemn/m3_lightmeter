import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/data/caffeine_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CaffeineService service;

  const methodChannel = MethodChannel('com.vodemn.lightmeter/keepScreenOn');
  Future<Object?>? methodCallSuccessHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "isKeepScreenOn":
        return true;
      case "setKeepScreenOn":
        return methodCall.arguments as bool;
      default:
        return null;
    }
  }

  setUp(() {
    service = const CaffeineService();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, methodCallSuccessHandler);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(methodChannel, null);
  });

  group(
    'isKeepScreenOn()',
    () {
      test('true', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(methodChannel, null);
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(methodChannel, (methodCall) async {
          switch (methodCall.method) {
            case "isKeepScreenOn":
              return true;
            default:
              return null;
          }
        });
        expectLater(service.isKeepScreenOn(), completion(true));
      });

      test('false', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(methodChannel, null);
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(methodChannel, (methodCall) async {
          switch (methodCall.method) {
            case "isKeepScreenOn":
              return false;
            default:
              return null;
          }
        });
        expectLater(service.isKeepScreenOn(), completion(false));
      });
    },
  );

  group(
    'keepScreenOn()',
    () {
      test('true', () async => expectLater(service.keepScreenOn(true), completion(true)));

      test('false', () async => expectLater(service.keepScreenOn(false), completion(false)));
    },
  );
}
