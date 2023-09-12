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
      selected: const Film.other(),
      child: widget.child,
    );
  }

  void setFilm(Film film) {}

  void saveFilms(List<Film> films) {}
}

class Films extends SelectableInheritedModel<Film> {
  const Films({
    super.key,
    required super.values,
    required super.selected,
    required super.child,
  });

  static List<Film> of(BuildContext context) {
    return InheritedModel.inheritFrom<Films>(context, aspect: SelectableAspect.list)!.values;
  }

  static Film selectedOf(BuildContext context) {
    return InheritedModel.inheritFrom<Films>(context, aspect: SelectableAspect.selected)!.selected;
  }
}
