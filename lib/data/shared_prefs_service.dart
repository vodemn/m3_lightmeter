import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/camera_feature.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/utils/color_to_int.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const isoKey = "iso";
  static const ndFilterKey = "ndFilter";

  static const evSourceTypeKey = "evSourceType";
  static const stopTypeKey = "stopType";
  static const showEv100Key = "showEv100";
  static const cameraEvCalibrationKey = "cameraEvCalibration";
  static const lightSensorEvCalibrationKey = "lightSensorEvCalibration";
  static const meteringScreenLayoutKey = "meteringScreenLayout";
  static const cameraFeaturesKey = "cameraFeatures";

  static const caffeineKey = "caffeine";
  static const hapticsKey = "haptics";
  static const autostartTimerKey = "autostartTimer";
  static const volumeActionKey = "volumeAction";
  static const localeKey = "locale";

  static const themeTypeKey = "themeType";
  static const primaryColorKey = "primaryColor";
  static const dynamicColorKey = "dynamicColor";

  static const seenChangelogVersionKey = "seenChangelogVersion";

  final SharedPreferences _sharedPreferences;

  UserPreferencesService(this._sharedPreferences) {
    migrateOldKeys();
  }

  @visibleForTesting
  Future<void> migrateOldKeys() async {
    final legacyIsoIndex = _sharedPreferences.getInt("curIsoIndex");
    if (legacyIsoIndex != null) {
      iso = IsoValue.values[legacyIsoIndex];
      await _sharedPreferences.remove("curIsoIndex");
    }

    final legacyNdIndex = _sharedPreferences.getInt("curndIndex");
    if (legacyNdIndex != null) {
      /// Legacy ND list has 1 extra value at the end, so this check is needed
      if (legacyNdIndex < NdValue.values.length) {
        ndFilter = NdValue.values[legacyNdIndex];
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

  IsoValue get iso => IsoValue.values.firstWhere((v) => v.value == (_sharedPreferences.getInt(isoKey) ?? 100));
  set iso(IsoValue value) => _sharedPreferences.setInt(isoKey, value.value);

  NdValue get ndFilter => NdValue.values.firstWhere((v) => v.value == (_sharedPreferences.getInt(ndFilterKey) ?? 0));
  set ndFilter(NdValue value) => _sharedPreferences.setInt(ndFilterKey, value.value);

  EvSourceType get evSourceType => EvSourceType.values[_sharedPreferences.getInt(evSourceTypeKey) ?? 0];
  set evSourceType(EvSourceType value) => _sharedPreferences.setInt(evSourceTypeKey, value.index);

  StopType get stopType => StopType.values[_sharedPreferences.getInt(stopTypeKey) ?? 2];
  set stopType(StopType value) => _sharedPreferences.setInt(stopTypeKey, value.index);

  bool get showEv100 => _sharedPreferences.getBool(showEv100Key) ?? false;
  set showEv100(bool value) => _sharedPreferences.setBool(showEv100Key, value);

  MeteringScreenLayoutConfig get meteringScreenLayout {
    final configJson = _sharedPreferences.getString(meteringScreenLayoutKey);
    if (configJson != null) {
      return MeteringScreenLayoutConfigJson.fromJson(
        json.decode(configJson) as Map<String, dynamic>,
      );
    } else {
      return {
        MeteringScreenLayoutFeature.equipmentProfiles: true,
        MeteringScreenLayoutFeature.extremeExposurePairs: true,
        MeteringScreenLayoutFeature.filmPicker: true,
      };
    }
  }

  set meteringScreenLayout(MeteringScreenLayoutConfig value) =>
      _sharedPreferences.setString(meteringScreenLayoutKey, json.encode(value.toJson()));

  CameraFeaturesConfig get cameraFeatures {
    final configJson = _sharedPreferences.getString(cameraFeaturesKey);
    if (configJson != null) {
      return CameraFeaturesConfigJson.fromJson(json.decode(configJson) as Map<String, dynamic>);
    } else {
      return {
        CameraFeature.spotMetering: false,
        CameraFeature.histogram: false,
      };
    }
  }

  set cameraFeatures(CameraFeaturesConfig value) =>
      _sharedPreferences.setString(cameraFeaturesKey, json.encode(value.toJson()));

  bool get caffeine => _sharedPreferences.getBool(caffeineKey) ?? false;
  set caffeine(bool value) => _sharedPreferences.setBool(caffeineKey, value);

  bool get haptics => _sharedPreferences.getBool(hapticsKey) ?? true;
  set haptics(bool value) => _sharedPreferences.setBool(hapticsKey, value);

  bool get autostartTimer => _sharedPreferences.getBool(autostartTimerKey) ?? true;
  set autostartTimer(bool value) => _sharedPreferences.setBool(autostartTimerKey, value);

  VolumeAction get volumeAction => VolumeAction.values.firstWhere(
        (e) => e.toString() == _sharedPreferences.getString(volumeActionKey),
        orElse: () => VolumeAction.shutter,
      );
  set volumeAction(VolumeAction value) => _sharedPreferences.setString(volumeActionKey, value.toString());

  SupportedLocale get locale => SupportedLocale.values.firstWhere(
        (e) => e.toString() == _sharedPreferences.getString(localeKey),
        orElse: () => SupportedLocale.en,
      );
  set locale(SupportedLocale value) => _sharedPreferences.setString(localeKey, value.toString());

  double get cameraEvCalibration => _sharedPreferences.getDouble(cameraEvCalibrationKey) ?? 0.0;
  set cameraEvCalibration(double value) => _sharedPreferences.setDouble(cameraEvCalibrationKey, value);

  double get lightSensorEvCalibration => _sharedPreferences.getDouble(lightSensorEvCalibrationKey) ?? 0.0;
  set lightSensorEvCalibration(double value) => _sharedPreferences.setDouble(lightSensorEvCalibrationKey, value);

  ThemeType get themeType => ThemeType.values[_sharedPreferences.getInt(themeTypeKey) ?? 0];
  set themeType(ThemeType value) => _sharedPreferences.setInt(themeTypeKey, value.index);

  Color get primaryColor => Color(_sharedPreferences.getInt(primaryColorKey) ?? 0xff2196f3);
  set primaryColor(Color value) => _sharedPreferences.setInt(primaryColorKey, value.toInt());

  bool get dynamicColor => _sharedPreferences.getBool(dynamicColorKey) ?? false;
  set dynamicColor(bool value) => _sharedPreferences.setBool(dynamicColorKey, value);

  String get seenChangelogVersion => _sharedPreferences.getString(seenChangelogVersionKey) ?? '';
  set seenChangelogVersion(String value) => _sharedPreferences.setString(seenChangelogVersionKey, value);
}
