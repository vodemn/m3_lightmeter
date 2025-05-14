import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:platform/platform.dart';

class VolumeEventsService {
  final LocalPlatform _localPlatform;

  @visibleForTesting
  static const volumeMethodChannel = MethodChannel("com.vodemn.lightmeter.VolumePlatformChannel.MethodChannel");

  @visibleForTesting
  static const volumeEventsChannel = EventChannel("com.vodemn.lightmeter.VolumePlatformChannel.EventChannel");

  const VolumeEventsService(this._localPlatform);

  /// If set to `false` we allow system to handle key events.
  /// Returns current status of volume handling.
  Future<bool> setVolumeHandling(bool enableHandling) async {
    if (!_localPlatform.isAndroid) {
      return false;
    }
    return volumeMethodChannel.invokeMethod<bool>("setVolumeHandling", enableHandling).then((value) => value!);
  }

  /// Emits new events on
  /// KEYCODE_VOLUME_UP = 24;
  /// KEYCODE_VOLUME_DOWN = 25;
  /// pressed
  Stream<int> volumeButtonsEventStream() {
    if (!_localPlatform.isAndroid) {
      return const Stream.empty();
    }
    return volumeEventsChannel.receiveBroadcastStream().cast<int>().where((event) => event == 24 || event == 25);
  }
}
