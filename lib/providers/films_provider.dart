import 'package:flutter/material.dart';
import 'package:lightmeter/utils/selectable_provider.dart';
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
  late List<Film> _filmsInUse;
  late Film _selected;

  @override
  void initState() {
    super.initState();
    _filmsInUse = widget.storageService.filmsInUse;
    _selected = widget.storageService.selectedFilm;
    _discardSelectedIfNotIncluded();
  }

  @override
  Widget build(BuildContext context) {
    return Films(
      values: [
        const Film.other(),
        ...widget.availableFilms ?? films,
      ],
      filmsInUse: [
        const Film.other(),
        if (IAPProducts.isPurchased(context, IAPProductType.paidFeatures)) ..._filmsInUse,
      ],
      selected: IAPProducts.isPurchased(context, IAPProductType.paidFeatures)
          ? _selected
          : const Film.other(),
      child: widget.child,
    );
  }

  void setFilm(Film film) {
    if (_selected != film) {
      _selected = film;
      widget.storageService.selectedFilm = film;
      setState(() {});
    }
  }

  void saveFilms(List<Film> films) {
    _filmsInUse = films;
    widget.storageService.filmsInUse = films;
    _discardSelectedIfNotIncluded();
    setState(() {});
  }

  void _discardSelectedIfNotIncluded() {
    if (_selected != const Film.other() && !_filmsInUse.contains(_selected)) {
      _selected = const Film.other();
      widget.storageService.selectedFilm = const Film.other();
    }
  }
}

class Films extends SelectableInheritedModel<Film> {
  final List<Film> filmsInUse;

  const Films({
    super.key,
    required super.values,
    required this.filmsInUse,
    required super.selected,
    required super.child,
  });

  /// [Film.other()] + all the custom fields with actual reciprocity formulas
  static List<Film> of(BuildContext context) {
    return InheritedModel.inheritFrom<Films>(context)!.values;
  }

  /// [Film.other()] + films in use selected by user
  static List<Film> inUseOf<T>(BuildContext context) {
    return InheritedModel.inheritFrom<Films>(
      context,
      aspect: SelectableAspect.list,
    )!
        .filmsInUse;
  }

  static Film selectedOf(BuildContext context) {
    return InheritedModel.inheritFrom<Films>(context, aspect: SelectableAspect.selected)!.selected;
  }
}
