import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

class RestorePurchasesListTile extends StatelessWidget {
  const RestorePurchasesListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.restore_outlined),
      title: Text(S.of(context).restorePurchases),
      onTap: IAPProductsProvider.maybeOf(context)?.restorePurchases,
    );
  }
}
