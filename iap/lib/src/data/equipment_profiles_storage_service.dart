part of 'package:m3_lightmeter_iap/src/data/iap_storage_service.dart';

mixin EquipmentProfilesStorageService on IapStorageServiceBase {
  static const String selectedEquipmentProfileIdKey = "selectedEquipmentProfileId";

  String get selectedEquipmentProfileId => '';
  set selectedEquipmentProfileId(String id) {}

  Future<void> addEquipmentProfile(EquipmentProfile profile) async {}

  Future<void> updateEquipmentProfile({
    required String id,
    String? name,
    List<IsoValue>? isoValues,
    List<NdValue>? ndValues,
    List<ApertureValue>? apertureValues,
    List<ShutterSpeedValue>? shutterSpeedValues,
    double? lensZoom,
    double? exposureOffset,
    bool? isUsed,
  }) async {}

  Future<void> deleteEquipmentProfile(String id) async {}

  Future<TogglableMap<EquipmentProfile>> getEquipmentProfiles() async => {};
}
