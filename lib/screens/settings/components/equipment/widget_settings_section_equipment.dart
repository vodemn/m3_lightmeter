import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/shared/settings_section/widget_settings_section.dart';

import 'components/equipment_profiles/widget_list_tile_equipment_profiles.dart';
import 'components/iso_values/widget_list_tile_iso_values.dart';
import 'components/nd_filters/widget_list_tile_nd_filters.dart';


class EquipmentSettingsSection extends StatelessWidget {
  const EquipmentSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      enabled: false,
      title: S.of(context).equipment,
      children: const [
        IsoValuesListTile(),
        NdFiltersListTile(),
        EquipmentProfilesListTile(),
      ],
    );
  }
}
