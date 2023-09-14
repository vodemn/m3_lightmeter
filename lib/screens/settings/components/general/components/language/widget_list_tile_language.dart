import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/supported_locale.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_picker/widget_dialog_picker.dart';

class LanguageListTile extends StatelessWidget {
  const LanguageListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(S.of(context).language),
      trailing: Text(UserPreferencesProvider.localeOf(context).localizedName),
      onTap: () {
        showDialog<SupportedLocale>(
          context: context,
          builder: (_) => DialogPicker<SupportedLocale>(
            icon: Icons.language,
            title: S.of(context).chooseLanguage,
            selectedValue: UserPreferencesProvider.localeOf(context),
            values: SupportedLocale.values,
            titleAdapter: (context, value) => value.localizedName,
          ),
        ).then((value) {
          if (value != null) {
            UserPreferencesProvider.of(context).setLocale(value);
          }
        });
      },
    );
  }
}
