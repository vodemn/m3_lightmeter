import 'package:flutter/material.dart';
import 'package:lightmeter/utils/context_utils.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmsProvider extends StatefulWidget {
  final IAPStorageService storageService;
  final List<Film>? availableFilms;
  final Widget child;

  const FilmsProvider({
    required this.storageService,
    this.availableFilms,
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
  late final Map<String, _SelectableFilm<Film>> predefinedFilms = Map.fromEntries(
    (widget.availableFilms ?? films).map(
      (film) => MapEntry(
        film.id,
        (
          film: film,
          selected: widget.storageService.filmsInUse.contains(film),
        ),
      ),
    ),
  );
  final Map<String, _SelectableFilm<FilmExponential>> customFilms = {};
  late Film _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.storageService.selectedFilm;
    _discardSelectedIfNotIncluded();
  }

  @override
  Widget build(BuildContext context) {
    return Films(
      predefinedFilms: predefinedFilms,
      customFilms: customFilms,
      selected: context.isPro ? _selected : const FilmStub(),
      child: widget.child,
    );
  }

  /* Both type of films **/

  void toggleFilm(Film film, bool enabled) {
    Film? targetFilm = predefinedFilms[film.id]?.film;
    if (targetFilm != null) {
      predefinedFilms[film.id] = (film: film, selected: enabled);
      _discardSelectedIfNotIncluded();
      setState(() {});
      return;
    }

    targetFilm = customFilms[film.id]?.film;
    if (targetFilm != null) {
      customFilms[film.id] = (film: film as FilmExponential, selected: enabled);
      _discardSelectedIfNotIncluded();
      setState(() {});
      return;
    }
  }

  void selectFilm(Film film) {
    if (_selected != film) {
      _selected = film;
      widget.storageService.selectedFilm = film;
      setState(() {});
    }
  }

  /* Custom films **/

  void addCustomFilm(FilmExponential film) {
    customFilms[film.id] = (film: film, selected: false);
    setState(() {});
  }

  void updateCustomFilm(FilmExponential film) {
    customFilms[film.id] = (film: film, selected: customFilms[film.id]!.selected);
    setState(() {});
  }

  void deleteCustomFilm(FilmExponential film) {
    customFilms.remove(film.id);
    _discardSelectedIfNotIncluded();
    setState(() {});
  }

  void _discardSelectedIfNotIncluded() {
    if (_selected != const FilmStub() &&
        !predefinedFilms.values.any((e) => e.film == _selected) &&
        !customFilms.values.any((e) => e.film == _selected)) {
      _selected = const FilmStub();
      widget.storageService.selectedFilm = const FilmStub();
    }
  }
}

typedef _SelectableFilm<T extends Film> = ({T film, bool selected});

enum _FilmsModelAspect {
  customFilmsList,
  predefinedFilmsList,
  filmsInUse,
  selected,
}

class Films extends InheritedModel<_FilmsModelAspect> {
  final Map<String, _SelectableFilm<Film>> predefinedFilms;

  @protected
  final Map<String, _SelectableFilm<FilmExponential>> customFilms;
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
      ...model.customFilms.values.where((e) => e.selected).map((e) => e.film),
      ...model.predefinedFilms.values.where((e) => e.selected).map((e) => e.film),
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
