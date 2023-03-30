import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/ev_source_type.dart';
import 'models/theme_type.dart';

class UserPreferencesService {
  static const _isoKey = "iso";
  static const _ndFilterKey = "ndFilter";

  static const _evSourceTypeKey = "evSourceType";
  static const _cameraEvCalibrationKey = "cameraEvCalibration";
  static const _lightSensorEvCalibrationKey = "lightSensorEvCalibration";

  static const _caffeineKey = "caffeine";
  static const _hapticsKey = "haptics";
  static const _localeKey = "locale";

  static const _themeTypeKey = "themeType";
  static const _primaryColorKey = "primaryColor";
  static const _dynamicColorKey = "dynamicColor";

  final SharedPreferences _sharedPreferences;

  UserPreferencesService(this._sharedPreferences) {
    _migrateOldKeys();
  }

  Future<void> _migrateOldKeys() async {
    final legacyIsoIndex = _sharedPreferences.getInt("curIsoIndex");
    if (legacyIsoIndex != null) {
      iso = isoValues[legacyIsoIndex];
      await _sharedPreferences.remove("curIsoIndex");
    }

    final legacyNdIndex = _sharedPreferences.getInt("curndIndex");
    if (legacyNdIndex != null) {
      /// Legacy ND list has 1 extra value at the end, so this check is needed
      if (legacyNdIndex < ndValues.length) {
        ndFilter = ndValues[legacyNdIndex];
      }
      await _sharedPreferences.remove("curndIndex");
    }

    final legacyCameraCalibration = _sharedPreferences.getDouble("cameraCalibr");
    if (legacyCameraCalibration != null) {
      cameraEvCalibration = legacyCameraCalibration;
      await _sharedPreferences.remove("cameraCalibr");
    }

    final legacyLightSensorCalibration = _sharedPreferences.getDouble("sensorCalibr");
    if (legacyLightSensorCalibration != null) {
      lightSensorEvCalibration = legacyLightSensorCalibration;
      await _sharedPreferences.remove("sensorCalibr");
    }

    final legacyHaptics = _sharedPreferences.getBool("vibrate");
    if (legacyHaptics != null) {
      haptics = legacyHaptics;
      await _sharedPreferences.remove("vibrate");
    }
  }

  IsoValue get iso =>
      isoValues.firstWhere((v) => v.value == (_sharedPreferences.getInt(_isoKey) ?? 100));
  set iso(IsoValue value) => _sharedPreferences.setInt(_isoKey, value.value);

  NdValue get ndFilter =>
      ndValues.firstWhere((v) => v.value == (_sharedPreferences.getInt(_ndFilterKey) ?? 0));
  set ndFilter(NdValue value) => _sharedPreferences.setInt(_ndFilterKey, value.value);

  EvSourceType get evSourceType =>
      EvSourceType.values[_sharedPreferences.getInt(_evSourceTypeKey) ?? 0];
  set evSourceType(EvSourceType value) => _sharedPreferences.setInt(_evSourceTypeKey, value.index);

  bool get caffeine => _sharedPreferences.getBool(_caffeineKey) ?? false;
  set caffeine(bool value) => _sharedPreferences.setBool(_caffeineKey, value);

  bool get haptics => _sharedPreferences.getBool(_hapticsKey) ?? true;
  set haptics(bool value) => _sharedPreferences.setBool(_hapticsKey, value);

  SupportedLocale get locale => SupportedLocale.values.firstWhere(
        (e) => e.toString() == _sharedPreferences.getString(_localeKey),
        orElse: () => SupportedLocale.en,
      );
  set locale(SupportedLocale value) => _sharedPreferences.setString(_localeKey, value.toString());

  double get cameraEvCalibration => _sharedPreferences.getDouble(_cameraEvCalibrationKey) ?? 0.0;
  set cameraEvCalibration(double value) =>
      _sharedPreferences.setDouble(_cameraEvCalibrationKey, value);

  double get lightSensorEvCalibration =>
      _sharedPreferences.getDouble(_lightSensorEvCalibrationKey) ?? 0.0;
  set lightSensorEvCalibration(double value) =>
      _sharedPreferences.setDouble(_lightSensorEvCalibrationKey, value);

  ThemeType get themeType => ThemeType.values[_sharedPreferences.getInt(_themeTypeKey) ?? 0];
  set themeType(ThemeType value) => _sharedPreferences.setInt(_themeTypeKey, value.index);

  Color get primaryColor => Color(_sharedPreferences.getInt(_primaryColorKey) ?? 0xff2196f3);
  set primaryColor(Color value) => _sharedPreferences.setInt(_primaryColorKey, value.value);

  bool get dynamicColor => _sharedPreferences.getBool(_dynamicColorKey) ?? false;
  set dynamicColor(bool value) => _sharedPreferences.setBool(_dynamicColorKey, value);

  String get selectedEquipmentProfileId => '';
  set selectedEquipmentProfileId(String id) {}

  List<EquipmentProfileData> get equipmentProfiles => [];
  set equipmentProfiles(List<EquipmentProfileData> profiles) {}
}
