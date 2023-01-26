import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';

class SettingsInteractor {
  final UserPreferencesService _userPreferencesService;
  final HapticsService _hapticsService;

  const SettingsInteractor(
    this._userPreferencesService,
    this._hapticsService,
  );

  double get cameraEvCalibration => _userPreferencesService.cameraEvCalibration;
  void setCameraEvCalibration(double value) => _userPreferencesService.cameraEvCalibration = value;

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
}
