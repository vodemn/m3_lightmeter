import 'package:flutter/material.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmListener extends StatefulWidget {
  final ValueChanged<Film> onDidChangeDependencies;
  final Widget child;

  const FilmListener({
    required this.onDidChangeDependencies,
    required this.child,
    super.key,
  });

  @override
  State<FilmListener> createState() => _FilmListenerState();
}

class _FilmListenerState extends State<FilmListener> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.onDidChangeDependencies(Films.selectedOf(context));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
