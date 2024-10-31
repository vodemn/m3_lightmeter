import 'package:flutter/material.dart';
import 'package:lightmeter/utils/context_utils.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmsProvider extends StatefulWidget {
  final FilmsStorageService filmsStorageService;
  final Widget child;

  const FilmsProvider({
    required this.filmsStorageService,
    required this.child,
    super.key,
  });

  static FilmsProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<FilmsProviderState>()!;
  }

  @override
  State<FilmsProvider> createState() => FilmsProviderState();
}

class FilmsProviderState extends State<FilmsProvider> {
  final Map<String, SelectableFilm<Film>> predefinedFilms = {};
  final Map<String, SelectableFilm<FilmExponential>> customFilms = {};
  late String _selectedId;

  Film get _selectedFilm => customFilms[_selectedId]?.film ?? predefinedFilms[_selectedId]?.film ?? const FilmStub();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Films(
      predefinedFilms: context.isPro ? predefinedFilms : {},
      customFilms: context.isPro ? customFilms : {},
      selected: context.isPro ? _selectedFilm : const FilmStub(),
      child: widget.child,
    );
  }

  /* Both type of films **/

  Future<void> toggleFilm(Film film, bool enabled) async {
    if (predefinedFilms.containsKey(film.id)) {
      predefinedFilms[film.id] = (film: film, isUsed: enabled);
    } else if (customFilms.containsKey(film.id)) {
      customFilms[film.id] = (film: film as FilmExponential, isUsed: enabled);
    } else {
      return;
    }
    await widget.filmsStorageService.toggleFilm(film, enabled);
    _discardSelectedIfNotIncluded();
    setState(() {});
  }

  void selectFilm(Film film) {
    if (_selectedFilm != film) {
      _selectedId = film.id;
      widget.filmsStorageService.selectedFilmId = _selectedId;
      setState(() {});
    }
  }

  /* Custom films **/

  Future<void> addCustomFilm(FilmExponential film) async {
    // ignore: avoid_redundant_argument_values
    await widget.filmsStorageService.addFilm(film, isUsed: true);
    customFilms[film.id] = (film: film, isUsed: true);
    setState(() {});
  }

  Future<void> updateCustomFilm(FilmExponential film) async {
    await widget.filmsStorageService.updateFilm(film);
    customFilms[film.id] = (film: film, isUsed: customFilms[film.id]!.isUsed);
    setState(() {});
  }

  Future<void> deleteCustomFilm(FilmExponential film) async {
    await widget.filmsStorageService.deleteFilm(film);
    customFilms.remove(film.id);
    _discardSelectedIfNotIncluded();
    setState(() {});
  }

  Future<void> _init() async {
    _selectedId = widget.filmsStorageService.selectedFilmId;
    predefinedFilms.addAll(await widget.filmsStorageService.getPredefinedFilms());
    customFilms.addAll(await widget.filmsStorageService.getCustomFilms());
    _discardSelectedIfNotIncluded();
    if (mounted) setState(() {});
  }

  void _discardSelectedIfNotIncluded() {
    if (_selectedId == const FilmStub().id) {
      return;
    }
    final isSelectedUsed = predefinedFilms[_selectedId]?.isUsed ?? customFilms[_selectedId]?.isUsed ?? false;
    if (!isSelectedUsed) {
      _selectedId = const FilmStub().id;
      widget.filmsStorageService.selectedFilmId = _selectedId;
    }
  }
}

enum _FilmsModelAspect {
  customFilmsList,
  predefinedFilmsList,
  filmsInUse,
  selected,
}

class Films extends InheritedModel<_FilmsModelAspect> {
  final Map<String, SelectableFilm<Film>> predefinedFilms;

  @protected
  final Map<String, SelectableFilm<FilmExponential>> customFilms;
  final Film selected;

  const Films({
    required this.predefinedFilms,
    required this.customFilms,
    required this.selected,
    required super.child,
  });

  static List<Film> predefinedFilmsOf<T>(BuildContext context) {
    return InheritedModel.inheritFrom<Films>(context, aspect: _FilmsModelAspect.predefinedFilmsList)!
        .predefinedFilms
        .values
        .map((value) => value.film)
        .toList();
  }

  static List<FilmExponential> customFilmsOf<T>(BuildContext context) {
    return InheritedModel.inheritFrom<Films>(context, aspect: _FilmsModelAspect.customFilmsList)!
        .customFilms
        .values
        .map((value) => value.film)
        .toList();
  }

  /// [FilmStub()] + films in use selected by user
  static List<Film> inUseOf<T>(BuildContext context) {
    final model = InheritedModel.inheritFrom<Films>(context, aspect: _FilmsModelAspect.filmsInUse)!;
    return [
      const FilmStub(),
      ...model.customFilms.values.where((e) => e.isUsed).map((e) => e.film),
      ...model.predefinedFilms.values.where((e) => e.isUsed).map((e) => e.film),
    ];
  }

  static Film selectedOf(BuildContext context) {
    return InheritedModel.inheritFrom<Films>(context, aspect: _FilmsModelAspect.selected)!.selected;
  }

  @override
  bool updateShouldNotify(Films _) => true;

  @override
  bool updateShouldNotifyDependent(Films oldWidget, Set<_FilmsModelAspect> dependencies) {
    // TODO: reduce unnecessary notifications
    return true;
  }
}
