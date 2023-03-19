import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

import 'components/equipment_profile_screen/screen_equipment_profile.dart';

class EquipmentProfilesListTile extends StatelessWidget {
  const EquipmentProfilesListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.camera),
      title: Text(S.of(context).equipmentProfiles),
      onTap: () {
        Navigator.of(context).push<EquipmentProfileData>(
            MaterialPageRoute(builder: (_) => const EquipmentProfileScreen()));
      },
    );
  }
}
