import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/components/shared/expandable_section_list/widget_expandable_section_list.dart';
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
        IconButton(
          onPressed: _addFilm,
          icon: const Icon(Icons.add_outlined),
          tooltip: S.of(context).tooltipAdd,
        ),
      ],
      slivers: [
        SliverFillRemaining(
          // The inner (body) scroll view must use this scroll controller so that
          // the independent scroll positions can be kept in sync.
          child: TabBarView(
            controller: tabController,
            children: [
              _FilmsListBuilder(
                films: Films.of(context).skip(1).toList(),
                onFilmSelected: (film, value) {},
              ),
              _FilmsListBuilder(
                films: Films.of(context).skip(1).toList(),
                onFilmSelected: (film, value) {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addFilm([EquipmentProfile? copyFrom]) {}
}

class _FilmsListBuilder extends StatelessWidget {
  final List<Film> films;
  final void Function(Film film, bool value) onFilmSelected;
  final void Function()? onFilmEdit;

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
                    onPressed: onFilmEdit,
                    icon: const Icon(Icons.edit),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
