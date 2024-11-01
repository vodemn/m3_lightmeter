import 'package:flutter/foundation.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

typedef SelectableFilm<T extends Film> = ({T film, bool isUsed});

class FilmsStorageService {
  FilmsStorageService();

  Future<void> init() async {}

  @visibleForTesting
  Future<void> createTable(dynamic _) async {}

  String get selectedFilmId => '';
  set selectedFilmId(String id) {}

  Future<void> addFilm(FilmExponential _, {bool isUsed = true}) async {}

  Future<void> updateFilm(FilmExponential _) async {}

  Future<void> toggleFilm(Film _, bool __) async {}

  Future<void> deleteFilm(FilmExponential _) async {}

  Future<Map<String, SelectableFilm<Film>>> getPredefinedFilms() async {
    return const {};
  }

  Future<Map<String, SelectableFilm<FilmExponential>>> getCustomFilms() async {
    return const {};
  }
}
