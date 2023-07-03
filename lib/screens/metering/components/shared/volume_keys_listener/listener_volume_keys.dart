import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';

class VolumeKeysListener {
  final MeteringInteractor _meteringInteractor;
  late final StreamSubscription<VolumeKey> _volumeKeysSubscription;

  VolumeKeysListener(
    this._meteringInteractor, {
    required VolumeAction action,
    required ValueChanged<VolumeKey> onKey,
  }) {
    _volumeKeysSubscription = _meteringInteractor.volumeKeysStream().listen((event) {
      if (_meteringInteractor.volumeAction == action) {
        onKey(event);
      }
    });

    // TODO: add RouteObserver and disable overriden action if SettingScreen is opened
  }

  Future<void> dispose() async {
    await _volumeKeysSubscription.cancel();
  }
}
