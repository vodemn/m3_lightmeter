import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/film_edit/flow_film_edit.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmsScreen extends StatefulWidget {
  const FilmsScreen({super.key});

  @override
  State<FilmsScreen> createState() => _FilmsScreenState();
}

class _FilmsScreenState extends State<FilmsScreen> with SingleTickerProviderStateMixin {
  late final tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverScreen(
      title: Text(S.of(context).films),
      bottom: TabBar(
        controller: tabController,
        tabs: [
          Tab(text: S.of(context).filmsInUse),
          Tab(text: S.of(context).filmsCustom),
        ],
      ),
      appBarActions: [
        AnimatedBuilder(
          animation: tabController,
          builder: (context, _) => AnimatedSwitcher(
            duration: Dimens.switchDuration,
            child: tabController.index == 0
                ? const SizedBox.shrink()
                : IconButton(
                    onPressed: _addFilm,
                    icon: const Icon(Icons.add_outlined),
                    tooltip: S.of(context).tooltipAdd,
                  ),
          ),
        ),
      ],
      slivers: [
        SliverFillRemaining(
          child: TabBarView(
            controller: tabController,
            children: [
              _FilmsListBuilder(
                films: Films.of(context).skip(1).toList(),
                onFilmSelected: (film, value) {},
              ),
              _FilmsListBuilder<FilmExponential>(
                films: Films.of(context).skip(1).whereType<FilmExponential>().toList(),
                onFilmSelected: (film, value) {},
                onFilmEdit: _editFilm,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addFilm() {
    Navigator.of(context).pushNamed(
      'filmEdit',
      arguments: const FilmEditArgs(film: FilmExponential(name: '', iso: 100, exponent: 1.3)),
    );
  }

  void _editFilm(FilmExponential film) {
    Navigator.of(context).pushNamed(
      'filmEdit',
      arguments: FilmEditArgs(film: film),
    );
  }
}

class _FilmsListBuilder<T extends Film> extends StatelessWidget {
  final List<T> films;
  final void Function(T film, bool value) onFilmSelected;
  final void Function(T film)? onFilmEdit;

  const _FilmsListBuilder({
    required this.films,
    required this.onFilmSelected,
    this.onFilmEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(Dimens.paddingM).add(EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom)),
      itemCount: films.length,
      itemBuilder: (_, index) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: index == 0 ? const Radius.circular(Dimens.borderRadiusL) : Radius.zero,
            topRight: index == 0 ? const Radius.circular(Dimens.borderRadiusL) : Radius.zero,
            bottomLeft: index == films.length - 1 ? const Radius.circular(Dimens.borderRadiusL) : Radius.zero,
            bottomRight: index == films.length - 1 ? const Radius.circular(Dimens.borderRadiusL) : Radius.zero,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: index == 0 ? Dimens.paddingM : 0.0,
            bottom: index == films.length - 1 ? Dimens.paddingM : 0.0,
          ),
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: Films.inUseOf(context).contains(films[index]),
            title: Text(films[index].name),
            onChanged: (value) {
              onFilmSelected(films[index], value ?? false);
            },
            secondary: onFilmEdit != null
                ? IconButton(
                    onPressed: () => onFilmEdit!(films[index]),
                    icon: const Icon(Icons.edit),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
