import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/animated_dialog/widget_dialog_animated.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/reading_value_container/widget_container_reading_value.dart';
import 'package:lightmeter/screens/settings/utils/show_buy_pro_dialog.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

class LightmeterProAnimatedDialog extends StatefulWidget {
  const LightmeterProAnimatedDialog({super.key});

  @override
  State<LightmeterProAnimatedDialog> createState() => _LightmeterProAnimatedDialogState();
}

class _LightmeterProAnimatedDialogState extends State<LightmeterProAnimatedDialog> {
  final _key = GlobalKey<AnimatedDialogState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        IAPProductsProvider.maybeOf(context)?.buy(IAPProductType.paidFeatures);
      },
      child: ReadingValueContainer(
        color: Theme.of(context).colorScheme.errorContainer,
        values: [
          ReadingValue(
            label: S.of(context).proFeatures,
            value: S.of(context).unlock,
          ),
        ],
      ),
    );
  }
}
