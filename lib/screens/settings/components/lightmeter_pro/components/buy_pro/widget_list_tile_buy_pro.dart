import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

class BuyProListTile extends StatelessWidget {
  const BuyProListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final status = IAPProducts.productOf(context, IAPProductType.paidFeatures)?.status;
    final isPending = status == IAPProductStatus.purchased || status == null;
    return ListTile(
      leading: const Icon(Icons.bolt),
      title: Text(S.of(context).getPro),
      onTap: !isPending
          ? () {
              Navigator.of(context).pushNamed('proFeatures');
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
