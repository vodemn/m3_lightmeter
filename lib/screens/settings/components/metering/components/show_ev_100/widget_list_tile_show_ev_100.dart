import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/components/shared/disable/widget_disable.dart';
import 'package:lightmeter/utils/context_utils.dart';

class ShowEv100ListTile extends StatelessWidget {
  const ShowEv100ListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Disable(
      disable: !context.isPro,
      child: SwitchListTile(
        secondary: const Icon(Icons.adjust),
        title: Text(S.of(context).showEv100),
        value: context.isPro && UserPreferencesProvider.showEv100Of(context),
        onChanged: (_) => UserPreferencesProvider.of(context).toggleShowEv100(),
        contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
      ),
    );
  }
}
