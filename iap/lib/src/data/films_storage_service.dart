part of 'package:m3_lightmeter_iap/src/data/iap_storage_service.dart';

mixin FilmsStorageService on IapStorageServiceBase {
  String get selectedFilmId => '';
  set selectedFilmId(String id) {}

  Future<void> addFilm(FilmExponential _, {bool isUsed = true}) async {}

  Future<void> updateFilm(FilmExponential _) async {}

  Future<void> toggleFilm(Film _, bool __) async {}

  Future<void> deleteFilm(FilmExponential _) async {}

  Future<TogglableMap<Film>> getPredefinedFilms() async => {};

  Future<TogglableMap<FilmExponential>> getCustomFilms() async => {};
}
