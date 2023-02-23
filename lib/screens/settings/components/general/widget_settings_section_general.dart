import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/shared/settings_section/widget_settings_section.dart';

import 'components/caffeine/provider_list_tile_caffeine.dart';
import 'components/haptics/provider_list_tile_haptics.dart';
import 'components/language/widget_list_tile_language.dart';

class GeneralSettingsSection extends StatelessWidget {
  const GeneralSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: S.of(context).general,
      children: const [
        CaffeineListTileProvider(),
        HapticsListTileProvider(),
        LanguageListTile(),
      ],
    );
  }
}
