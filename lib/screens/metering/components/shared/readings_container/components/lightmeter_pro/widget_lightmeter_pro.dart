import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/animated_dialog/widget_dialog_animated.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/reading_value_container/widget_container_reading_value.dart';
import 'package:lightmeter/screens/shared/pro_features_dialog/widget_dialog_pro_features.dart';

class LightmeterProAnimatedDialog extends StatelessWidget {
  const LightmeterProAnimatedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedDialog(
      closedChild: ReadingValueContainer(
        color: Theme.of(context).colorScheme.errorContainer,
        values: [
          ReadingValue(
            label: S.of(context).proFeatures,
            value: S.of(context).unlock,
          ),
        ],
      ),
      openedChild: const ProFeaturesDialog(),
      openedSize: Size.fromHeight(const ProFeaturesDialog().height(context)),
    );
  }
}
