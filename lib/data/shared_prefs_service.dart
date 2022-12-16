import 'package:lightmeter/data/models/nd_value.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/iso_value.dart';

class UserPreferencesService {
  static const _isoKey = "ISO";
  static const _ndFilterKey = "ND";

  static const _themeTypeKey = "ThemeType";

  final SharedPreferences _sharedPreferences;

  UserPreferencesService(this._sharedPreferences);

  IsoValue get iso => isoValues.firstWhere((v) => v.value == (_sharedPreferences.getInt(_isoKey) ?? 100));
  set iso(IsoValue value) => _sharedPreferences.setInt(_isoKey, value.value);

  NdValue get ndFilter => ndValues.firstWhere((v) => v.value == (_sharedPreferences.getInt(_ndFilterKey) ?? 0));
  set ndFilter(NdValue value) => _sharedPreferences.setInt(_ndFilterKey, value.value);

  ThemeType get themeType => ThemeType.values[_sharedPreferences.getInt(_themeTypeKey) ?? 0];
  set themeType(ThemeType value) => _sharedPreferences.setInt(_themeTypeKey, value.index);
}
