import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/screens/film_edit/bloc_film_edit.dart';
import 'package:lightmeter/screens/film_edit/screen_film_edit.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmEditArgs {
  final FilmExponential film;

  const FilmEditArgs({required this.film});
}

class FilmEditFlow extends StatelessWidget {
  final FilmEditArgs args;

  const FilmEditFlow({required this.args, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FilmEditBloc(args.film),
      child: const FilmEditScreen(),
    );
  }
}
