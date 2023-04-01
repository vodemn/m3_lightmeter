import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:provider/provider.dart';

class FilmProvider extends StatefulWidget {
  final Widget child;

  const FilmProvider({required this.child, super.key});

  static FilmProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<FilmProviderState>()!;
  }

  @override
  State<FilmProvider> createState() => FilmProviderState();
}

class FilmProviderState extends State<FilmProvider> {
  late FilmData _selectedFilm;

  @override
  void initState() {
    super.initState();
    _selectedFilm = context.read<UserPreferencesService>().film;
  }

  @override
  Widget build(BuildContext context) {
    return Film(
      data: _selectedFilm,
      child: widget.child,
    );
  }

  void setFilm(FilmData data) {
    setState(() {
      _selectedFilm = data;
    });
    context.read<UserPreferencesService>().film = _selectedFilm;
  }
}

class Film extends InheritedWidget {
  final FilmData data;

  const Film({
    required this.data,
    required super.child,
    super.key,
  });

  static FilmData of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<Film>()!.data;
    } else {
      return context.findAncestorWidgetOfExactType<Film>()!.data;
    }
  }

  @override
  bool updateShouldNotify(Film oldWidget) => true;
}
