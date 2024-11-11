import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/navigation/routes.dart';
import 'package:lightmeter/screens/settings/components/shared/iap_list_tile/widget_list_tile_iap.dart';

class EquipmentProfilesListTile extends StatelessWidget {
  const EquipmentProfilesListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return IAPListTile(
      leading: const Icon(Icons.camera_outlined),
      title: Text(S.of(context).equipmentProfiles),
      onTap: () {
        Navigator.of(context).pushNamed(NavigationRoutes.equipmentProfilesListScreen.name);
      },
    );
  }
}
