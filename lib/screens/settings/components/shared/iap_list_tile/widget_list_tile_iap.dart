import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/components/utils/show_buy_pro_dialog.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

/// Depends on the product status and replaces [onTap] with purchase callback
/// if the product is purchasable.
class IAPListTile extends StatelessWidget {
  final IAPProductType product;
  final Icon leading;
  final Text title;
  final VoidCallback onTap;
  final bool showPendingTrailing;

  const IAPListTile({
    this.product = IAPProductType.paidFeatures,
    required this.leading,
    required this.title,
    required this.onTap,
    this.showPendingTrailing = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final status = IAPProducts.productOf(context, IAPProductType.paidFeatures)?.status;
    final isPending = status == IAPProductStatus.purchased || status == null;
    return ListTile(
      leading: leading,
      title: title,
      onTap: switch (status) {
        IAPProductStatus.purchasable => () => showBuyProDialog(context),
        IAPProductStatus.pending => null,
        IAPProductStatus.purchased => onTap,
        null => null,
      },
      trailing: showPendingTrailing && isPending
          ? const SizedBox(
              height: Dimens.grid24,
              width: Dimens.grid24,
              child: CircularProgressIndicator(),
            )
          : null,
    );
  }
}
