import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/dynamic_colors_state.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/dimens.dart';

class DynamicColorListTile extends StatelessWidget {
  const DynamicColorListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(Icons.colorize_outlined),
      title: Text(S.of(context).dynamicColor),
      value: UserPreferencesProvider.dynamicColorStateOf(context) == DynamicColorState.enabled,
      onChanged: UserPreferencesProvider.of(context).enableDynamicColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
    );
  }
}
