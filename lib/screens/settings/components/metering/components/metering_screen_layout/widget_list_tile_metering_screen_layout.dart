import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_switch/widget_dialog_switch.dart';
import 'package:lightmeter/utils/context_utils.dart';
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
            values: UserPreferencesProvider.meteringScreenConfigOf(context),
            titleAdapter: _toStringLocalized,
            enabledAdapter: (value) {
              switch (value) {
                case MeteringScreenLayoutFeature.equipmentProfiles:
                case MeteringScreenLayoutFeature.filmPicker:
                  return context.isPro;
                default:
                  return true;
              }
            },
            onSave: (value) {
              if (!value[MeteringScreenLayoutFeature.equipmentProfiles]!) {
                EquipmentProfileProvider.of(context).setProfile(EquipmentProfiles.of(context).first);
              }
              if (!value[MeteringScreenLayoutFeature.filmPicker]!) {
                FilmsProvider.of(context).setFilm(const Film.other());
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
