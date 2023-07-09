import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/dynamic_colors_state.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/theme_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/utils/inherited_generics.dart';

class DynamicColorListTile extends StatelessWidget {
  const DynamicColorListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(Icons.colorize),
      title: Text(S.of(context).dynamicColor),
      value: context.listen<DynamicColorState>() == DynamicColorState.enabled,
      onChanged: ThemeProvider.of(context).enableDynamicColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
    );
  }
}
