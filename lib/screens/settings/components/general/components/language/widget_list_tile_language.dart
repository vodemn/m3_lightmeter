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
      leading: const Icon(Icons.language_outlined),
      title: Text(S.of(context).language),
      trailing: Text(UserPreferencesProvider.localeOf(context).localizedName),
      onTap: () {
        final prefs = UserPreferencesProvider.of(context);
        showDialog<SupportedLocale>(
          context: context,
          builder: (_) => DialogPicker<SupportedLocale>(
            icon: Icons.language_outlined,
            title: S.of(context).chooseLanguage,
            selectedValue: UserPreferencesProvider.localeOf(context),
            values: SupportedLocale.values,
            titleAdapter: (_, value) => value.localizedName,
          ),
        ).then((value) {
          if (value != null) {
            prefs.setLocale(value);
          }
        });
      },
    );
  }
}
