import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/metering/components/equipment_profiles/components/equipment_profile_screen/screen_equipment_profile.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class EquipmentProfilesListTile extends StatelessWidget {
  const EquipmentProfilesListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final paidStatus = IAPProducts.productOf(context, IAPProductType.paidFeatures)?.status;
    log(paidStatus.toString());
    return ListTile(
      leading: const Icon(Icons.camera),
      title: Text(S.of(context).equipmentProfiles),
      onTap: switch (paidStatus) {
        IAPProductStatus.purchased => () {
            Navigator.of(context).push<EquipmentProfile>(
              MaterialPageRoute(builder: (_) => const EquipmentProfilesScreen()),
            );
          },
        IAPProductStatus.purchasable => () {
            IAPProductsProvider.of(context).buy(IAPProductType.paidFeatures);
          },
        _ => null,
      },
      trailing: switch (paidStatus) {
        IAPProductStatus.purchasable => const Icon(Icons.lock),
        _ => null,
      },
    );
  }
}
