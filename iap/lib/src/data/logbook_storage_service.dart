import 'dart:async';

import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class LogbookPhotosStorageService {
  LogbookPhotosStorageService();

  Future<void> init() async {}

  Future<void> addPhoto(LogbookPhoto profile) async {}

  Future<void> updatePhoto({
    required String id,
    String? note,
    ApertureValue? apertureValue,
    bool removeApertureValue = false,
    ShutterSpeedValue? shutterSpeedValue,
    bool removeShutterSpeedValue = false,
  }) async {}

  Future<void> deletePhoto(String id) async {}

  Future<List<LogbookPhoto>> getPhotos() async => [];
}
