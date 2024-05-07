import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/data/volume_events_service.dart';

class SettingsInteractor {
  final UserPreferencesService _userPreferencesService;
  final CaffeineService _caffeineService;
  final HapticsService _hapticsService;
  final VolumeEventsService _volumeEventsService;

  const SettingsInteractor(
    this._userPreferencesService,
    this._caffeineService,
    this._hapticsService,
    this._volumeEventsService,
  );

  double get cameraEvCalibration => _userPreferencesService.cameraEvCalibration;
  void setCameraEvCalibration(double value) => _userPreferencesService.cameraEvCalibration = value;

  double get lightSensorEvCalibration => _userPreferencesService.lightSensorEvCalibration;
  void setLightSensorEvCalibration(double value) => _userPreferencesService.lightSensorEvCalibration = value;

  bool get isCaffeineEnabled => _userPreferencesService.caffeine;
  Future<void> enableCaffeine(bool enable) async {
    await _caffeineService.keepScreenOn(enable).then((value) {
      _userPreferencesService.caffeine = enable;
    });
  }

  bool get isAutostartTimerEnabled => _userPreferencesService.autostartTimer;
  void enableAutostartTimer(bool enable) => _userPreferencesService.autostartTimer = enable;

  Future<void> disableVolumeHandling() async {
    await _volumeEventsService.setVolumeHandling(false);
  }

  Future<void> restoreVolumeHandling() async {
    await _volumeEventsService.setVolumeHandling(_userPreferencesService.volumeAction != VolumeAction.none);
  }

  VolumeAction get volumeAction => _userPreferencesService.volumeAction;
  Future<void> setVolumeAction(VolumeAction value) async {
    _userPreferencesService.volumeAction = value;
    await _volumeEventsService.setVolumeHandling(value != VolumeAction.none);
  }

  bool get isHapticsEnabled => _userPreferencesService.haptics;
  void enableHaptics(bool enable) {
    _userPreferencesService.haptics = enable;
    quickVibration();
  }

  /// Executes vibration if haptics are enabled in settings
  void quickVibration() {
    if (_userPreferencesService.haptics) _hapticsService.quickVibration();
  }

  /// Executes vibration if haptics are enabled in settings
  void responseVibration() {
    if (_userPreferencesService.haptics) _hapticsService.responseVibration();
  }
}
