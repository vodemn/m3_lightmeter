import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/dimens.dart';

class ShowEv100ListTile extends StatelessWidget {
  const ShowEv100ListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: const Icon(Icons.adjust),
      title: Text(S.of(context).showEv100),
      value: UserPreferencesProvider.showEv100Of(context),
      onChanged: (_) => UserPreferencesProvider.of(context).toggleShowEV100(),
      contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
    );
  }
}
