import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_switch/widget_dialog_switch.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class MeteringScreenLayoutListTile extends StatelessWidget {
  const MeteringScreenLayoutListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.layers_outlined),
      title: Text(S.of(context).meteringScreenLayout),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => DialogSwitch<MeteringScreenLayoutFeature>(
            icon: Icons.layers_outlined,
            title: S.of(context).meteringScreenLayout,
            description: S.of(context).meteringScreenLayoutHint,
            items: UserPreferencesProvider.meteringScreenConfigOf(context)
                .entries
                .map(
                  (entry) => DialogSwitchListItem(
                    value: entry.key,
                    title: _toStringLocalized(context, entry.key),
                    initialValue: UserPreferencesProvider.meteringScreenFeatureOf(context, entry.key),
                  ),
                )
                .toList(growable: false),
            onSave: (value) {
              if (!value[MeteringScreenLayoutFeature.equipmentProfiles]!) {
                EquipmentProfilesProvider.of(context).selectProfile(EquipmentProfiles.of(context).first.id);
              }
              if (!value[MeteringScreenLayoutFeature.filmPicker]!) {
                FilmsProvider.of(context).selectFilm(const FilmStub());
              }
              UserPreferencesProvider.of(context).setMeteringScreenLayout(value);
            },
          ),
        );
      },
    );
  }

  String _toStringLocalized(BuildContext context, MeteringScreenLayoutFeature feature) {
    switch (feature) {
      case MeteringScreenLayoutFeature.equipmentProfiles:
        return S.of(context).meteringScreenLayoutHintEquipmentProfiles;
      case MeteringScreenLayoutFeature.extremeExposurePairs:
        return S.of(context).meteringScreenFeatureExtremeExposurePairs;
      case MeteringScreenLayoutFeature.filmPicker:
        return S.of(context).meteringScreenFeatureFilmPicker;
    }
  }
}
