import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/data/volume_events_service.dart';

class VolumeKeysNotifier extends ChangeNotifier {
  final VolumeEventsService volumeEventsService;
  late final StreamSubscription<VolumeKey> _volumeKeysSubscription;
  VolumeKey _value = VolumeKey.up;

  VolumeKeysNotifier(this.volumeEventsService) {
    // TODO: add RouteObserver and disable overriden action if SettingScreen is opened
    _volumeKeysSubscription = volumeEventsService
        .volumeButtonsEventStream()
        .where((event) => event == 24 || event == 25)
        .map((event) => event == 24 ? VolumeKey.up : VolumeKey.down)
        .listen((event) {
      value = event;
    });
  }

  VolumeKey get value => _value;
  set value(VolumeKey newValue) {
    _value = newValue;
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await _volumeKeysSubscription.cancel();
    super.dispose();
  }
}
