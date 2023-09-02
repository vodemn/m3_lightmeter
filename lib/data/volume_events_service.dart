import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:platform/platform.dart';

class VolumeEventsService {
  final LocalPlatform localPlatform;

  @visibleForTesting
  static const volumeHandlingChannel = MethodChannel("com.vodemn.lightmeter/volumeHandling");

  @visibleForTesting
  static const volumeEventsChannel = EventChannel("com.vodemn.lightmeter/volumeEvents");

  const VolumeEventsService(this.localPlatform);

  /// If set to `false` we allow system to handle key events.
  /// Returns current status of volume handling.
  Future<bool> setVolumeHandling(bool enableHandling) async {
    if (!localPlatform.isAndroid) {
      return false;
    }
    return volumeHandlingChannel
        .invokeMethod<bool>("setVolumeHandling", enableHandling)
        .then((value) => value!);
  }

  /// Emits new events on
  /// KEYCODE_VOLUME_UP = 24;
  /// KEYCODE_VOLUME_DOWN = 25;
  /// pressed
  Stream<int> volumeButtonsEventStream() {
    if (!localPlatform.isAndroid) {
      return const Stream.empty();
    }
    return volumeEventsChannel
        .receiveBroadcastStream()
        .cast<int>()
        .where((event) => event == 24 || event == 25);
  }
}
