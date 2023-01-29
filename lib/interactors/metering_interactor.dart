import 'dart:io';

import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';

class MeteringInteractor {
  final UserPreferencesService _userPreferencesService;
  final HapticsService _hapticsService;
  final LightSensorService _lightSensorService;

  const MeteringInteractor(
    this._userPreferencesService,
    this._hapticsService,
    this._lightSensorService,
  );

  double get cameraEvCalibration => _userPreferencesService.cameraEvCalibration;
  double get lightSensorEvCalibration => _userPreferencesService.lightSensorEvCalibration;

  bool get isHapticsEnabled => _userPreferencesService.haptics;

  /// Executes vibration if haptics are enabled in settings
  void quickVibration() {
    if (_userPreferencesService.haptics) _hapticsService.quickVibration();
  }

  /// Executes vibration if haptics are enabled in settings
  void responseVibration() {
    if (_userPreferencesService.haptics) _hapticsService.responseVibration();
  }

  void enableHaptics(bool enable) => _userPreferencesService.haptics = enable;

  Future<bool> hasAmbientLightSensor() async {
    if (Platform.isAndroid) {
      return _lightSensorService.hasSensor();
    } else {
      return false;
    }
  }

  Stream<int> luxStream() => _lightSensorService.luxStream();
}
