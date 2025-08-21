import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/navigation/routes.dart';

class EquipmentProfilesListTile extends StatelessWidget {
  const EquipmentProfilesListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.camera_alt_outlined),
      title: Text(S.of(context).equipmentProfiles),
      onTap: () {
        Navigator.of(context).pushNamed(NavigationRoutes.equipmentProfilesListScreen.name);
      },
    );
  }
}
