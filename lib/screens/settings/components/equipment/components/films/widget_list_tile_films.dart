import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_filter/widget_dialog_filter.dart';
import 'package:lightmeter/screens/settings/components/shared/iap_builder/widget_builder_iap.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

class FilmsListTile extends StatelessWidget {
  const FilmsListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return IAPBuilder(
      builder: (context, status) => ListTile(
        leading: const Icon(Icons.camera_roll),
        title: Text(S.of(context).filmsInUse),
        onTap: status == IAPProductStatus.purchased
            ? () {
                showDialog<List<Film>>(
                  context: context,
                  builder: (_) => DialogFilter<Film>(
                    icon: const Icon(Icons.camera_roll),
                    title: S.of(context).filmsInUse,
                    description: S.of(context).filmsInUseDescription,
                    values: Film.values.sublist(1),
                    selectedValues: Film.values.sublist(1),
                    titleAdapter: (_, value) => value.name,
                  ),
                ).then((values) {
                  if (values != null) {}
                });
              }
            : null,
      ),
    );
  }
}
