import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/equipment/components/equipment_profiles/components/equipment_profile_screen/screen_equipment_profile.dart';
import 'package:lightmeter/screens/settings/components/shared/iap_builder/widget_builder_iap.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class EquipmentProfilesListTile extends StatelessWidget {
  const EquipmentProfilesListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return IAPBuilder(
      builder: (context, status) => ListTile(
        leading: const Icon(Icons.camera),
        title: Text(S.of(context).equipmentProfiles),
        onTap: status == IAPProductStatus.purchased
            ? () {
                Navigator.of(context).push<EquipmentProfile>(
                  MaterialPageRoute(builder: (_) => const EquipmentProfilesScreen()),
                );
              }
            : null,
      ),
    );
  }
}
