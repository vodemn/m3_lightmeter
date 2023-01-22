import 'package:shared_preferences/shared_preferences.dart';

import 'models/photography_values/iso_value.dart';
import 'models/photography_values/nd_value.dart';
import 'models/theme_type.dart';

class UserPreferencesService {
  static const _isoKey = "iso";
  static const _ndFilterKey = "nd";

  static const _hapticsKey = "haptics";
  static const _themeTypeKey = "themeType";
  static const _dynamicColorsKey = "dynamicColors";

  final SharedPreferences _sharedPreferences;

  UserPreferencesService(this._sharedPreferences);

  IsoValue get iso => isoValues.firstWhere((v) => v.value == (_sharedPreferences.getInt(_isoKey) ?? 100));
  set iso(IsoValue value) => _sharedPreferences.setInt(_isoKey, value.value);

  NdValue get ndFilter => ndValues.firstWhere((v) => v.value == (_sharedPreferences.getInt(_ndFilterKey) ?? 0));
  set ndFilter(NdValue value) => _sharedPreferences.setInt(_ndFilterKey, value.value);

  bool get haptics => _sharedPreferences.getBool(_hapticsKey) ?? false;
  set haptics(bool value) => _sharedPreferences.setBool(_hapticsKey, value);

  ThemeType get themeType => ThemeType.values[_sharedPreferences.getInt(_themeTypeKey) ?? 0];
  set themeType(ThemeType value) => _sharedPreferences.setInt(_themeTypeKey, value.index);

  bool get dynamicColors => _sharedPreferences.getBool(_dynamicColorsKey) ?? false;
  set dynamicColors(bool value) => _sharedPreferences.setBool(_dynamicColorsKey, value);
}
