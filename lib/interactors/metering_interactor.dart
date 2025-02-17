import 'package:app_settings/app_settings.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:permission_handler/permission_handler.dart';

class MeteringInteractor {
  final UserPreferencesService _userPreferencesService;
  final CaffeineService _caffeineService;
  final HapticsService _hapticsService;
  final PermissionsService _permissionsService;
  final LightSensorService _lightSensorService;
  final VolumeEventsService _volumeEventsService;

  MeteringInteractor(
    this._userPreferencesService,
    this._caffeineService,
    this._hapticsService,
    this._permissionsService,
    this._lightSensorService,
    this._volumeEventsService,
  );

  void initialize() {
    if (_userPreferencesService.caffeine) {
      _caffeineService.keepScreenOn(true);
    }
    _volumeEventsService.setVolumeHandling(_userPreferencesService.volumeAction != VolumeAction.none);
  }

  double get cameraEvCalibration => _userPreferencesService.cameraEvCalibration;
  double get lightSensorEvCalibration => _userPreferencesService.lightSensorEvCalibration;
  bool get isHapticsEnabled => _userPreferencesService.haptics;

  IsoValue get iso => _userPreferencesService.iso;
  set iso(IsoValue value) => _userPreferencesService.iso = value;

  NdValue get ndFilter => _userPreferencesService.ndFilter;
  set ndFilter(NdValue value) => _userPreferencesService.ndFilter = value;

  VolumeAction get volumeAction => _userPreferencesService.volumeAction;

  /// Executes vibration if haptics are enabled in settings
  Future<void> quickVibration() async {
    if (_userPreferencesService.haptics) await _hapticsService.quickVibration();
  }

  /// Executes vibration if haptics are enabled in settings
  Future<void> responseVibration() async {
    if (_userPreferencesService.haptics) await _hapticsService.responseVibration();
  }

  /// Executes vibration if haptics are enabled in settings
  Future<void> errorVibration() async {
    if (_userPreferencesService.haptics) await _hapticsService.errorVibration();
  }

  Future<bool> checkCameraPermission() async {
    return _permissionsService.checkCameraPermission().then((value) => value == PermissionStatus.granted);
  }

  Future<bool> requestCameraPermission() async {
    return _permissionsService.requestCameraPermission().then((value) => value == PermissionStatus.granted);
  }

  void openAppSettings() {
    AppSettings.openAppSettings();
  }

  Future<bool> hasAmbientLightSensor() async => _lightSensorService.hasSensor();

  Stream<int> luxStream() => _lightSensorService.luxStream();

  void setCameraFocalLength(int focalLength) => _userPreferencesService.cameraFocalLength = focalLength;
}
