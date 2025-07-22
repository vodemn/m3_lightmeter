import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lightmeter/utils/context_utils.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmsProvider extends StatefulWidget {
  final IapStorageService storageService;
  final VoidCallback? onInitialized;
  final Widget child;

  const FilmsProvider({
    required this.storageService,
    this.onInitialized,
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
  final TogglableMap<Film> predefinedFilms = {};
  final TogglableMap<FilmExponential> customFilms = {};
  String _selectedId = '';

  Film get _selectedFilm => customFilms[_selectedId]?.value ?? predefinedFilms[_selectedId]?.value ?? const FilmStub();

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

  Future<void> _init() async {
    _selectedId = widget.storageService.selectedFilmId;
    predefinedFilms.addAll(await widget.storageService.getPredefinedFilms());
    customFilms.addAll(await widget.storageService.getCustomFilms());
    _discardSelectedIfNotIncluded();
    if (mounted) setState(() {});
    widget.onInitialized?.call();
  }

  /* Both type of films **/

  Future<void> toggleFilm(Film film, bool enabled) async {
    if (predefinedFilms.containsKey(film.id)) {
      predefinedFilms[film.id] = (value: film, isUsed: enabled);
    } else if (customFilms.containsKey(film.id)) {
      customFilms[film.id] = (value: film as FilmExponential, isUsed: enabled);
    } else {
      return;
    }
    await widget.storageService.toggleFilm(film, enabled);
    _discardSelectedIfNotIncluded();
    setState(() {});
  }

  void selectFilm(Film film) {
    if (_selectedFilm != film) {
      _selectedId = film.id;
      widget.storageService.selectedFilmId = _selectedId;
      setState(() {});
    }
  }

  /* Custom films **/

  Future<void> addCustomFilm(FilmExponential film) async {
    // ignore: avoid_redundant_argument_values
    await widget.storageService.addFilm(film, isUsed: true);
    customFilms[film.id] = (value: film, isUsed: true);
    setState(() {});
  }

  Future<void> updateCustomFilm(FilmExponential film) async {
    await widget.storageService.updateFilm(film);
    customFilms[film.id] = (value: film, isUsed: customFilms[film.id]!.isUsed);
    setState(() {});
  }

  Future<void> deleteCustomFilm(FilmExponential film) async {
    await widget.storageService.deleteFilm(film);
    customFilms.remove(film.id);
    _discardSelectedIfNotIncluded();
    setState(() {});
  }

  void _discardSelectedIfNotIncluded() {
    if (_selectedId == const FilmStub().id) {
      return;
    }
    final isSelectedUsed = predefinedFilms[_selectedId]?.isUsed ?? customFilms[_selectedId]?.isUsed ?? false;
    if (!isSelectedUsed) {
      _selectedId = const FilmStub().id;
      widget.storageService.selectedFilmId = _selectedId;
    }
  }
}

enum _FilmsModelAspect {
  customFilms,
  predefinedFilms,
  filmsInUse,
  selected,
}

class Films extends InheritedModel<_FilmsModelAspect> {
  final TogglableMap<Film> predefinedFilms;

  @protected
  final TogglableMap<FilmExponential> customFilms;
  final Film selected;

  const Films({
    required this.predefinedFilms,
    required this.customFilms,
    required this.selected,
    required super.child,
  });

  static List<Film> predefinedFilmsOf<T>(BuildContext context) {
    return InheritedModel.inheritFrom<Films>(context, aspect: _FilmsModelAspect.predefinedFilms)!
        .predefinedFilms
        .values
        .map((value) => value.value)
        .toList();
  }

  static List<FilmExponential> customFilmsOf<T>(BuildContext context) {
    return InheritedModel.inheritFrom<Films>(context, aspect: _FilmsModelAspect.customFilms)!
        .customFilms
        .values
        .map((value) => value.value)
        .toList();
  }

  /// [FilmStub()] + films in use selected by user
  static List<Film> inUseOf<T>(BuildContext context) {
    final model = InheritedModel.inheritFrom<Films>(context, aspect: _FilmsModelAspect.filmsInUse)!;
    return [
      const FilmStub(),
      ...model.customFilms.values.where((e) => e.isUsed).map((e) => e.value),
      ...model.predefinedFilms.values.where((e) => e.isUsed).map((e) => e.value),
    ];
  }

  static Film selectedOf(BuildContext context) {
    return InheritedModel.inheritFrom<Films>(context, aspect: _FilmsModelAspect.selected)!.selected;
  }

  @override
  bool updateShouldNotify(Films _) => true;

  @override
  bool updateShouldNotifyDependent(Films oldWidget, Set<_FilmsModelAspect> dependencies) {
    return (dependencies.contains(_FilmsModelAspect.selected) && oldWidget.selected != selected) ||
        ((dependencies.contains(_FilmsModelAspect.predefinedFilms) ||
                dependencies.contains(_FilmsModelAspect.filmsInUse)) &&
            const DeepCollectionEquality().equals(oldWidget.predefinedFilms, predefinedFilms)) ||
        ((dependencies.contains(_FilmsModelAspect.customFilms) ||
                dependencies.contains(_FilmsModelAspect.filmsInUse)) &&
            const DeepCollectionEquality().equals(oldWidget.customFilms, customFilms));
  }
}
