import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';

class EquipmentProfilesListTile extends StatelessWidget {
  const EquipmentProfilesListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.camera),
      title: Text(S.of(context).equipmentProfiles),
    );
  }
}
