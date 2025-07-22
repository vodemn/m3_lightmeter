import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

part 'equipment_profiles_storage_service.dart';
part 'films_storage_service.dart';
part 'logbook_photos_storage_service.dart';

class IapStorageService extends IapStorageServiceBase
    with EquipmentProfilesStorageService, FilmsStorageService, LogbookPhotosStorageService {
  IapStorageService(); // coverage:ignore-line
}

abstract class IapStorageServiceBase {
  IapStorageServiceBase();

  Future<void> init() async {}
}
