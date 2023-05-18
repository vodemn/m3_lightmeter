import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/dynamic_colors_state.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/theme_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/components/theme/components/primary_color/components/primary_color_picker_dialog/widget_dialog_picker_primary_color.dart';
import 'package:lightmeter/utils/inherited_generics.dart';

class PrimaryColorListTile extends StatelessWidget {
  const PrimaryColorListTile({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.listen<DynamicColorState>() == DynamicColorState.enabled) {
      return Opacity(
        opacity: Dimens.disabledOpacity,
        child: IgnorePointer(
          child: ListTile(
            leading: const Icon(Icons.palette),
            title: Text(S.of(context).primaryColor),
          ),
        ),
      );
    }
    return ListTile(
      leading: const Icon(Icons.palette),
      title: Text(S.of(context).primaryColor),
      onTap: () {
        showDialog<Color>(
          context: context,
          builder: (_) => const PrimaryColorDialogPicker(),
        ).then((value) {
          if (value != null) {
            ThemeProvider.of(context).setPrimaryColor(value);
          }
        });
      },
    );
  }
}
