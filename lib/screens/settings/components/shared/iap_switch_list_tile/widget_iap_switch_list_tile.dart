import 'package:flutter/material.dart';
import 'package:lightmeter/navigation/routes.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/utils/context_utils.dart';

class IAPSwitchListTile extends StatelessWidget {
  final Icon secondary;
  final Text title;
  final Text? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const IAPSwitchListTile({
    required this.secondary,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: secondary,
      title: title,
      subtitle: subtitle,
      value: context.isPro && value,
      contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
      onChanged: context.isPro
          ? onChanged
          : (_) {
              Navigator.of(context).pushNamed(NavigationRoutes.proFeaturesScreen.name);
            },
    );
  }
}
