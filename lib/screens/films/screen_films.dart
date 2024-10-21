import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:lightmeter/screens/films/components/film_formula_input/widget_film_formula_input.dart';
import 'package:lightmeter/screens/settings/components/shared/expandable_section_list/widget_expandable_section_list.dart';
import 'package:lightmeter/screens/shared/sliver_screen/screen_sliver.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmsScreen extends StatefulWidget {
  const FilmsScreen({super.key});

  @override
  State<FilmsScreen> createState() => _FilmsScreenState();
}

class _FilmsScreenState extends State<FilmsScreen> {
  @override
  Widget build(BuildContext context) {
    return SliverScreen(
      title: Text('Films'),
      appBarActions: [
        IconButton(
          onPressed: _addFilm,
          icon: const Icon(Icons.add_outlined),
          tooltip: S.of(context).tooltipAdd,
        ),
      ],
      slivers: [
        ExpandableSectionList<FilmExponential>(
          values: [],
          onSectionTitleTap: () {},
          contentBuilder: (context, value) => [
            ListTile(
              leading: const Icon(Icons.iso),
              title: Text(S.of(context).iso),
              trailing: Text(value.iso.toString()),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.equalizer),
              title: Text('Formula'),
              trailing: Text(value.exponent.toString()),
            ),
          ],
          actionsBuilder: (context, value) => [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.copy_outlined),
              tooltip: S.of(context).tooltipCopy,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete_outlined),
              tooltip: S.of(context).tooltipDelete,
            ),
          ],
        ),
        SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom)),
      ],
    );
  }

  void _addFilm([EquipmentProfile? copyFrom]) {
    showDialog<String>(
      context: context,
      builder: (_) => const FilmFormulaDialog(),
    ).then((name) {
      if (name != null) {
        FilmsProvider.of(context).addFilm(name);
      }
    });
  }
}
