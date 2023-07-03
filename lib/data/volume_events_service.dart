import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class VolumeEventsService {
  @visibleForTesting
  static const volumeHandlingChannel = MethodChannel("com.vodemn.lightmeter/volumeHandling");

  @visibleForTesting
  static const volumeEventsChannel = EventChannel("com.vodemn.lightmeter/volumeEvents");

  const VolumeEventsService();

  /// Returns current status of volume handling
  Future<bool> setVolumeHandling(bool enableHandling) async {
    return volumeHandlingChannel
        .invokeMethod<bool>("setVolumeHandling", enableHandling)
        .then((value) => value!);
  }

  /// Emits new events on
  /// KEYCODE_VOLUME_UP = 24;
  /// KEYCODE_VOLUME_DOWN = 25;
  /// pressed
  Stream<int> volumeButtonsEventStream() {
    return volumeEventsChannel.receiveBroadcastStream().cast<int>();
  }
}
