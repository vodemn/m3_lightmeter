import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/theme_type.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/theme_provider.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_picker.dart/widget_dialog_picker.dart';
import 'package:provider/provider.dart';

class ThemeTypeListTile extends StatelessWidget {
  const ThemeTypeListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.brightness_6),
      title: Text(S.of(context).theme),
      trailing: Text(_typeToString(context, context.watch<ThemeType>())),
      onTap: () {
        showDialog<ThemeType>(
          context: context,
          builder: (_) => DialogPicker<ThemeType>(
            icon: Icons.brightness_6,
            title: S.of(context).chooseTheme,
            selectedValue: context.read<ThemeType>(),
            values: ThemeType.values,
            titleAdapter: _typeToString,
          ),
        ).then((value) {
          if (value != null) {
            ThemeProvider.of(context).setThemeType(value);
          }
        });
      },
    );
  }

  String _typeToString(BuildContext context, ThemeType themeType) {
    switch (themeType) {
      case ThemeType.light:
        return S.of(context).themeLight;
      case ThemeType.dark:
        return S.of(context).themeDark;
      case ThemeType.systemDefault:
        return S.of(context).themeSystemDefault;
    }
  }
}
