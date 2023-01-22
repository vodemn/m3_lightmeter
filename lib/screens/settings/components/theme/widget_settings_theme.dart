import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/dynamic_colors_state.dart';
import 'package:provider/provider.dart';

import 'components/widget_list_tile_dynamic_colors.dart';
import 'components/widget_list_tile_theme_type.dart';

class ThemeSettings extends StatelessWidget {
  const ThemeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ThemeTypeListTile(),
        if (context.read<DynamicColorsState>() != DynamicColorsState.unavailable) const DynamicColorsListTile(),
      ],
    );
  }
}
