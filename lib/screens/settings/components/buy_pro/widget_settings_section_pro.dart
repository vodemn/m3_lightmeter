import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/buy_pro/components/equipment_profiles/widget_list_tile_buy_pro.dart';
import 'package:lightmeter/screens/settings/components/shared/settings_section/widget_settings_section.dart';

class BuyProSettingsSection extends StatelessWidget {
  const BuyProSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: S.of(context).lightmeterPro,
      children: const [BuyProListTile()],
    );
  }
}
