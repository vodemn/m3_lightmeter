import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/reading_value_container/widget_container_reading_value.dart';

class LightmeterProAnimatedDialog extends StatelessWidget {
  const LightmeterProAnimatedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('proFeatures');
      },
      child: ReadingValueContainer(
        color: Theme.of(context).colorScheme.errorContainer,
        textColor: Theme.of(context).colorScheme.onErrorContainer,
        values: [
          ReadingValue(
            label: S.of(context).proFeaturesTitle,
            value: S.of(context).unlock,
          ),
        ],
      ),
    );
  }
}
