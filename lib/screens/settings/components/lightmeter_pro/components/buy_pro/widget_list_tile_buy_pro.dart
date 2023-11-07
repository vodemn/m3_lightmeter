import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/feature.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/remote_config_provider.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/utils/show_buy_pro_dialog.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

class BuyProListTile extends StatelessWidget {
  const BuyProListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final unlockFeaturesEnabled = RemoteConfig.isEnabled(context, Feature.unlockProFeaturesText);
    final status = IAPProducts.productOf(context, IAPProductType.paidFeatures)?.status;
    final isPending = status == IAPProductStatus.purchased || status == null;
    return ListTile(
      leading: const Icon(Icons.star),
      title: Text(unlockFeaturesEnabled ? S.of(context).unlockProFeatures : S.of(context).buyLightmeterPro),
      onTap: !isPending
          ? () {
              showBuyProDialog(context);
              ServicesProvider.of(context)
                  .analytics
                  .logUnlockProFeatures(unlockFeaturesEnabled ? 'Unlock Pro features' : 'Buy Lightmeter Pro');
            }
          : null,
      trailing: isPending
          ? const SizedBox(
              height: Dimens.grid24,
              width: Dimens.grid24,
              child: CircularProgressIndicator(),
            )
          : null,
    );
  }
}
