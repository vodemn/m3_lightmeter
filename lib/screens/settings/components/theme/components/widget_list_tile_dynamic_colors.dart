import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/dynamic_colors_state.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/theme.dart';

class DynamicColorsListTile extends StatelessWidget {
  const DynamicColorsListTile({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<DynamicColorsState>() == DynamicColorsState.unavailable) {
      return Opacity(
        opacity: 0.5,
        child: IgnorePointer(
          child: SwitchListTile(
            secondary: const Icon(Icons.colorize),
            title: Text(S.of(context).dynamicColors),
            value: false,
            enableFeedback: false,
            onChanged: (value) {},
          ),
        ),
      );
    }
    return SwitchListTile(
      secondary: const Icon(Icons.colorize),
      title: Text(S.of(context).dynamicColors),
      value: context.watch<DynamicColorsState>() == DynamicColorsState.enabled,
      onChanged: ThemeProvider.of(context).enableDynamicColors,
    );
  }
}
