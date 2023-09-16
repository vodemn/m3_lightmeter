import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/buy_pro/components/equipment_profiles/components/equipment_profile_screen/screen_buy_pro.dart';

class BuyProListTile extends StatelessWidget {
  const BuyProListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.camera),
      title: Text(S.of(context).buyLightmeterPro),
      onTap: () {
        Navigator.of(context).push<bool>(
          MaterialPageRoute(builder: (_) => const BuyProScreen()),
        );
      },
    );
  }
}
