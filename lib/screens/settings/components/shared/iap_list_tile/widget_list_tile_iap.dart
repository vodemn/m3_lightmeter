import 'package:flutter/material.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

/// Depends on the product status and replaces [onTap] with purchase callback
/// if the product is purchasable.
class IAPListTile extends StatelessWidget {
  final IAPProductType product;
  final Icon leading;
  final Text title;
  final VoidCallback onTap;

  const IAPListTile({
    this.product = IAPProductType.paidFeatures,
    required this.leading,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: title,
      onTap: switch (IAPProducts.productOf(context, product)?.status) {
        IAPProductStatus.purchasable => () => IAPProductsProvider.of(context).buy(product),
        IAPProductStatus.pending => null,
        IAPProductStatus.purchased => onTap,
        null => null,
      },
    );
  }
}
