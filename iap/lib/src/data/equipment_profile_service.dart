import 'dart:async';

import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class EquipmentProfilesStorageService {
  EquipmentProfilesStorageService();

  Future<void> init() async {}

  String get selectedEquipmentProfileId => '';
  set selectedEquipmentProfileId(String id) {}

  Future<void> addProfile(EquipmentProfile profile) async {}

  Future<void> updateProfile({
    required String id,
    String? name,
    List<IsoValue>? isoValues,
    List<NdValue>? ndValues,
    List<ApertureValue>? apertureValues,
    List<ShutterSpeedValue>? shutterSpeedValues,
    double? lensZoom,
    bool? isUsed,
  }) async {}

  Future<void> deleteProfile(String id) async {}

  Future<TogglableMap<EquipmentProfile>> getProfiles() async => {};
}
