import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmsStorageService {
  FilmsStorageService();

  Future<void> init() async {}

  String get selectedFilmId => '';
  set selectedFilmId(String id) {}

  Future<void> addFilm(FilmExponential _, {bool isUsed = true}) async {}

  Future<void> updateFilm(FilmExponential _) async {}

  Future<void> toggleFilm(Film _, bool __) async {}

  Future<void> deleteFilm(FilmExponential _) async {}

  Future<TogglableMap<Film>> getPredefinedFilms() async {
    return const {};
  }

  Future<TogglableMap<FilmExponential>> getCustomFilms() async {
    return const {};
  }
}
