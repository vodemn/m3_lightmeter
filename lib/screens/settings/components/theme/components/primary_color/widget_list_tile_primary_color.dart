import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/dynamic_colors_state.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/screens/settings/components/shared/disable/widget_disable.dart';
import 'package:lightmeter/screens/settings/components/theme/components/primary_color/components/primary_color_picker_dialog/widget_dialog_picker_primary_color.dart';

class PrimaryColorListTile extends StatelessWidget {
  const PrimaryColorListTile({super.key});

  @override
  Widget build(BuildContext context) {
    if (UserPreferencesProvider.dynamicColorStateOf(context) == DynamicColorState.enabled) {
      return Disable(
        child: ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: Text(S.of(context).primaryColor),
        ),
      );
    }
    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: Text(S.of(context).primaryColor),
      onTap: () {
        final prefs = UserPreferencesProvider.of(context);
        showDialog<Color>(
          context: context,
          builder: (_) => const PrimaryColorDialogPicker(),
        ).then((value) {
          if (value != null) {
            prefs.setPrimaryColor(value);
          }
        });
      },
    );
  }
}
