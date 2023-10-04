import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

Future<void> showBuyProDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      icon: const Icon(Icons.star),
      titlePadding: Dimens.dialogIconTitlePadding,
      title: Text(S.of(context).lightmeterPro),
      contentPadding: const EdgeInsets.symmetric(horizontal: Dimens.paddingL),
      content: SingleChildScrollView(child: Text(S.of(context).lightmeterProDescription)),
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
          },
          child: Text(S.of(context).buy),
        ),
      ],
    ),
  );
}
