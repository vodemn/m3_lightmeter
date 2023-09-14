import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/equipment/components/equipment_profiles/widget_list_tile_equipment_profiles.dart';
import 'package:lightmeter/screens/settings/components/equipment/components/films/widget_list_tile_films.dart';
import 'package:lightmeter/screens/settings/components/shared/settings_section/widget_settings_section.dart';

class EquipmentSettingsSection extends StatelessWidget {
  const EquipmentSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: S.of(context).equipment,
      children: const [
        EquipmentProfilesListTile(),
        FilmsListTile(),
      ],
    );
  }
}
