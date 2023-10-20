import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_filter/widget_dialog_filter.dart';
import 'package:lightmeter/screens/settings/components/shared/iap_list_tile/widget_list_tile_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class FilmsListTile extends StatelessWidget {
  const FilmsListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return IAPListTile(
      leading: const Icon(Icons.camera_roll),
      title: Text(S.of(context).filmsInUse),
      onTap: () {
        showDialog<List<Film>>(
          context: context,
          builder: (_) => DialogFilter<Film>(
            icon: const Icon(Icons.camera_roll),
            title: S.of(context).filmsInUse,
            description: S.of(context).filmsInUseDescription,
            values: Films.of(context).sublist(1),
            selectedValues: Films.inUseOf(context),
            titleAdapter: (_, value) => value.name,
          ),
        ).then((values) {
          if (values != null) {
            FilmsProvider.of(context).saveFilms(values);
          }
        });
      },
    );
  }
}
