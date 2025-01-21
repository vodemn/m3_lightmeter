import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/navigation/routes.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/reading_value_container/widget_container_reading_value.dart';

class LightmeterProAnimatedDialog extends StatelessWidget {
  const LightmeterProAnimatedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(NavigationRoutes.proFeaturesScreen.name);
      },
      child: ReadingValueContainer(
        color: Theme.of(context).colorScheme.secondary,
        textColor: Theme.of(context).colorScheme.onSecondary,
        values: [
          ReadingValue(
            label: S.of(context).proFeaturesTitle,
            value: S.of(context).getPro,
          ),
        ],
      ),
    );
  }
}
