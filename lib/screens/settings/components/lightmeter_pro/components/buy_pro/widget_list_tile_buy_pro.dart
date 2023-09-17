import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/shared/iap_list_tile/widget_list_tile_iap.dart';
import 'package:lightmeter/screens/settings/components/utils/show_buy_pro_dialog.dart';

class BuyProListTile extends StatelessWidget {
  const BuyProListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return IAPListTile(
      leading: const Icon(Icons.star),
      title: Text(S.of(context).buyLightmeterPro),
      onTap: () {
        showBuyProDialog(context);
      },
      showPendingTrailing: true,
    );
  }
}
