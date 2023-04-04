import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/supported_locale_provider.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_picker.dart/widget_dialog_picker.dart';
import 'package:provider/provider.dart';

class LanguageListTile extends StatelessWidget {
  const LanguageListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(S.of(context).language),
      trailing: Text(context.watch<SupportedLocale>().localizedName),
      onTap: () {
        showDialog<SupportedLocale>(
          context: context,
          builder: (_) => DialogPicker<SupportedLocale>(
            icon: Icons.language,
            title: S.of(context).chooseLanguage,
            selectedValue: context.read<SupportedLocale>(),
            values: SupportedLocale.values,
            titleAdapter: (context, value) => value.localizedName,
          ),
        ).then((value) {
          if (value != null) {
            SupportedLocaleProvider.of(context).setLocale(value);
          }
        });
      },
    );
  }
}
