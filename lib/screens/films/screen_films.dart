import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/navigation/routes.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/film_edit/flow_film_edit.dart';
import 'package:lightmeter/screens/shared/sliver_placeholder/widget_sliver_placeholder.dart';
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
  void initState() {
    super.initState();
    tabController.addListener(() {
      setState(() {});
    });
  }

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
        if (tabController.index == 0)
          _FilmsListBuilder(
            films: Films.predefinedFilmsOf(context).toList(),
            onFilmSelected: FilmsProvider.of(context).toggleFilm,
          )
        else if (tabController.index == 1 && Films.customFilmsOf(context).isNotEmpty)
          _FilmsListBuilder<FilmExponential>(
            films: Films.customFilmsOf(context).toList(),
            onFilmSelected: FilmsProvider.of(context).toggleFilm,
            onFilmEdit: _editFilm,
          )
        else
          SliverPlaceholder(onTap: _addFilm),
      ],
    );
  }

  void _addFilm() {
    Navigator.of(context).pushNamed(
      NavigationRoutes.filmEditScreen.name,
      arguments: const FilmEditArgs(),
    );
  }

  void _editFilm(FilmExponential film) {
    Navigator.of(context).pushNamed(
      NavigationRoutes.filmEditScreen.name,
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
    return SliverList.builder(
      itemCount: films.length,
      itemBuilder: (_, index) => Padding(
        padding: EdgeInsets.fromLTRB(
          Dimens.paddingM,
          index == 0 ? Dimens.paddingM : 0,
          Dimens.paddingM,
          index == films.length - 1 ? Dimens.paddingM + MediaQuery.paddingOf(context).bottom : 0.0,
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: index == 0 ? const Radius.circular(Dimens.borderRadiusL) : Radius.zero,
              bottom: index == films.length - 1 ? const Radius.circular(Dimens.borderRadiusL) : Radius.zero,
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
      ),
    );
  }
}
