import 'package:flutter/material.dart';
import 'package:lightmeter/screens/settings/components/shared/disable/widget_disable.dart';
import 'package:lightmeter/utils/context_utils.dart';
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
    return Disable(
      disable: !context.isPro,
      child: ListTile(
        leading: leading,
        title: title,
        onTap: onTap,
      ),
    );
  }
}
