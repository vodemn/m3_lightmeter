import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';

class TimerInteractor {
  final UserPreferencesService _userPreferencesService;
  final HapticsService _hapticsService;

  TimerInteractor(
    this._userPreferencesService,
    this._hapticsService,
  );

  /// Executes vibration if haptics are enabled in settings
  Future<void> quickVibration() async {
    if (_userPreferencesService.haptics) await _hapticsService.quickVibration();
  }

  /// Executes vibration if haptics are enabled in settings
  Future<void> responseVibration() async {
    if (_userPreferencesService.haptics) await _hapticsService.responseVibration();
  }
}
