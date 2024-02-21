import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> sendMockVolumeAction(String channelName, int keyCode) async {
  await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
    channelName,
    const StandardMethodCodec().encodeSuccessEnvelope(keyCode),
    (ByteData? data) {},
  );
}
