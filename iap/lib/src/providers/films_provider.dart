import 'package:flutter/material.dart';
import 'package:m3_lightmeter_iap/src/providers/selectable_provider.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmsProvider extends StatefulWidget {
  final Widget child;

  const FilmsProvider({
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
  @override
  Widget build(BuildContext context) {
    return Films(
      values: const [Film.other()],
      filmsInUse: const [Film.other()],
      selected: const Film.other(),
      child: widget.child,
    );
  }

  void setFilm(Film film) {}

  void saveFilms(List<Film> films) {}
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
