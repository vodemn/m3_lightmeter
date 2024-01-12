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
      openedChild: ProFeaturesDialog(),
      openedSize: Size.fromHeight(height(context)),
    );
  }

  double height(BuildContext context) {
    double textHeight(
      BuildContext context,
      String text,
      TextStyle? style,
      double horizontalPadding,
    ) {
      final TextPainter titlePainter = TextPainter(
        text: TextSpan(
          text: text,
          style: style,
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: MediaQuery.of(context).size.width - Dimens.dialogMargin.horizontal - horizontalPadding);
      return titlePainter.size.height;
    }

    final titleHeight = textHeight(
      context,
      S.of(context).unlockProFeatures,
      Theme.of(context).textTheme.headlineSmall,
      Dimens.dialogIconTitlePadding.horizontal,
    );
    final contentHeight = textHeight(
      context,
      S.of(context).unlockProFeaturesDescription,
      Theme.of(context).textTheme.bodyMedium,
      Dimens.paddingL * 2,
    );

    return (IconTheme.of(context).size! + Dimens.dialogTitlePadding.vertical) + // icon + icon padding
        (titleHeight + Dimens.dialogIconTitlePadding.vertical) + // title + title padding
        contentHeight +
        (48 + Dimens.dialogActionsPadding.vertical); // actions + actions padding
  }
}
