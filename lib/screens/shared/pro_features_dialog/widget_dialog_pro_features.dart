import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/animated_dialog/widget_dialog_animated.dart';
import 'package:lightmeter/screens/shared/transparent_dialog/widget_dialog_transparent.dart';
import 'package:lightmeter/utils/text_height.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

class ProFeaturesDialog extends StatelessWidget {
  const ProFeaturesDialog({super.key});

  double height(BuildContext context) => TransparentDialog.height(
        context,
        title: S.of(context).proFeatures,
        contextHeight: dialogTextHeight(
          context,
          S.of(context).unlockProFeaturesDescription,
          Theme.of(context).textTheme.bodyMedium,
          Dimens.paddingL * 2,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return TransparentDialog(
      icon: Icons.star,
      title: S.of(context).proFeatures,
      scrollableContent: false,
      content: Flexible(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingL),
            child: Text(
              S.of(context).unlockProFeaturesDescription,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _close(context),
          child: Text(S.of(context).cancel),
        ),
        FilledButton(
          onPressed: () {
            _close(context).then((_) {
              ServicesProvider.maybeOf(context)
                  ?.analytics
                  .setCustomKey('iap_product_type', IAPProductType.paidFeatures.storeId);
              IAPProductsProvider.maybeOf(context)?.buy(IAPProductType.paidFeatures);
            });
          },
          child: Text(S.of(context).unlock),
        ),
      ],
    );
  }

  Future<void> _close(BuildContext context) async => AnimatedDialog.maybeClose(context) ?? Navigator.of(context).pop();
}
