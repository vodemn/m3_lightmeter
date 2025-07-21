part of 'package:m3_lightmeter_iap/src/data/iap_storage_service.dart';

mixin LogbookPhotosStorageService on IapStorageServiceBase {
  bool get saveLogbookPhotos => false;
  set saveLogbookPhotos(bool value) {}

  Future<void> addPhoto(LogbookPhoto profile) async {}

  Future<void> updatePhoto({
    required String id,
    String? note,
    Optional<ApertureValue>? apertureValue,
    Optional<ShutterSpeedValue>? shutterSpeedValue,
  }) async {}

  Future<void> deletePhoto(String id) async {}

  Future<List<LogbookPhoto>> getPhotos() async => [];
}
