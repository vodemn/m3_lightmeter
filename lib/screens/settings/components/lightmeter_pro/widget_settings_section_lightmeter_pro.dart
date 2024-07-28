import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/lightmeter_pro/components/buy_pro/widget_list_tile_buy_pro.dart';
import 'package:lightmeter/screens/settings/components/lightmeter_pro/components/restore_purchases/widget_list_tile_restore_purchases.dart';
import 'package:lightmeter/screens/settings/components/shared/settings_section/widget_settings_section.dart';

class LightmeterProSettingsSection extends StatelessWidget {
  const LightmeterProSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      foregroundColor: Theme.of(context).colorScheme.onSecondary,
      title: S.of(context).proFeaturesTitle,
      children: const [
        BuyProListTile(),
        RestorePurchasesListTile(),
      ],
    );
  }
}
