import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/screens/film_edit/bloc_film_edit.dart';
import 'package:lightmeter/screens/film_edit/screen_film_edit.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmEditFlow extends StatelessWidget {
  final FilmExponential film;

  const FilmEditFlow(this.film, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FilmEditBloc(film),
      child: const FilmEditScreen(),
    );
  }
}
