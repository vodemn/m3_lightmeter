import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/feature.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/remote_config_provider.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

Future<void> showBuyProDialog(BuildContext context) {
  final unlockFeaturesEnabled = RemoteConfig.isEnabled(context, Feature.unlockProFeaturesText);
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      icon: const Icon(Icons.star),
      titlePadding: Dimens.dialogIconTitlePadding,
      title: Text(unlockFeaturesEnabled ? S.of(context).proFeatures : S.of(context).lightmeterPro),
      contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingL),
      content: SingleChildScrollView(
        child: Text(
          unlockFeaturesEnabled ? S.of(context).unlockProFeaturesDescription : S.of(context).lightmeterProDescription,
        ),
      ),
      actionsPadding: Dimens.dialogActionsPadding,
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(S.of(context).cancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            IAPProductsProvider.of(context).buy(IAPProductType.paidFeatures);
            ServicesProvider.of(context)
                .analytics
                .logProFeaturesPurchaseAttempt(unlockFeaturesEnabled ? "Unlock" : "Buy");
          },
          child: Text(unlockFeaturesEnabled ? S.of(context).unlock : S.of(context).buy),
        ),
      ],
    ),
  );
}
