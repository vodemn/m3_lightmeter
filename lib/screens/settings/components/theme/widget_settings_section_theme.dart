import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/dynamic_colors_state.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/enum_providers.dart';
import 'package:lightmeter/screens/settings/components/shared/settings_section/widget_settings_section.dart';
import 'package:lightmeter/screens/settings/components/theme/components/dynamic_color/widget_list_tile_dynamic_color.dart';
import 'package:lightmeter/screens/settings/components/theme/components/primary_color/widget_list_tile_primary_color.dart';
import 'package:lightmeter/screens/settings/components/theme/components/theme_type/widget_list_tile_theme_type.dart';

class ThemeSettingsSection extends StatelessWidget {
  const ThemeSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: S.of(context).theme,
      children: [
        const ThemeTypeListTile(),
        const PrimaryColorListTile(),
        if (EnumProviders.dynamicColorStateOf(context) != DynamicColorState.unavailable)
          const DynamicColorListTile(),
      ],
    );
  }
}
