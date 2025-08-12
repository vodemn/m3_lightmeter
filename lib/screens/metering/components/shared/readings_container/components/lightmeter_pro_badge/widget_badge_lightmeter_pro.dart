import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/navigation/routes.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/utils/text_height.dart';

class LightmeterProBadge extends StatelessWidget {
  const LightmeterProBadge({super.key});

  static double height(BuildContext context) {
    if (Theme.of(context).textTheme.titleMedium?.lineHeight case final lineHeight?) {
      return Dimens.paddingS * 2 + lineHeight;
    } else {
      return 40;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(NavigationRoutes.proFeaturesScreen.name);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.borderRadiusM),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.paddingM,
          vertical: Dimens.paddingS,
        ),
        child: Text(
          S.of(context).getPro,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
      ),
    );
  }
}
