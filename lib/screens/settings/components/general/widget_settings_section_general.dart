import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/general/components/caffeine/provider_list_tile_caffeine.dart';
import 'package:lightmeter/screens/settings/components/general/components/haptics/provider_list_tile_haptics.dart';
import 'package:lightmeter/screens/settings/components/general/components/language/widget_list_tile_language.dart';
import 'package:lightmeter/screens/settings/components/general/components/volume_actions/provider_list_tile_volume_actions.dart';
import 'package:lightmeter/screens/settings/components/shared/settings_section/widget_settings_section.dart';

class GeneralSettingsSection extends StatelessWidget {
  const GeneralSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: S.of(context).general,
      children: [
        const CaffeineListTileProvider(),
        const HapticsListTileProvider(),
        if (Platform.isAndroid) const VolumeActionsListTileProvider(),
        const LanguageListTile(),
      ],
    );
  }
}
