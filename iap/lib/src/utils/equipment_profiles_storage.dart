import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension EquipmentProfilesStorage on SharedPreferences {
  String get selectedEquipmentProfileId => '';
  set selectedEquipmentProfileId(String id) {}

  List<EquipmentProfileData> get equipmentProfiles => [];
  set equipmentProfiles(List<EquipmentProfileData> profiles) {}
}
