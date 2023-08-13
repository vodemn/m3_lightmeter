import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/dynamic_colors_state.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/enum_providers.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/components/theme/components/primary_color/components/primary_color_picker_dialog/widget_dialog_picker_primary_color.dart';

class PrimaryColorListTile extends StatelessWidget {
  const PrimaryColorListTile({super.key});

  @override
  Widget build(BuildContext context) {
    if (EnumProviders.dynamicColorStateOf(context) == DynamicColorState.enabled) {
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
            EnumProviders.of(context).setPrimaryColor(value);
          }
        });
      },
    );
  }
}
