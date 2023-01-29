import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/dynamic_colors_state.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/theme_provider.dart';

class DynamicColorListTile extends StatelessWidget {
  const DynamicColorListTile({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.read<DynamicColorState>() == DynamicColorState.unavailable) {
      return Opacity(
        opacity: 0.5,
        child: IgnorePointer(
          child: SwitchListTile(
            secondary: const Icon(Icons.colorize),
            title: Text(S.of(context).dynamicColor),
            value: false,
            enableFeedback: false,
            onChanged: (value) {},
          ),
        ),
      );
    }
    return SwitchListTile(
      secondary: const Icon(Icons.colorize),
      title: Text(S.of(context).dynamicColor),
      value: context.watch<DynamicColorState>() == DynamicColorState.enabled,
      onChanged: ThemeProvider.of(context).enableDynamicColor,
    );
  }
}
