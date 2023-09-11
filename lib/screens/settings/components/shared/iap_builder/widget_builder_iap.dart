import 'package:flutter/material.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

class IAPBuilder extends StatelessWidget {
  final IAPProductType product;
  final Widget Function(BuildContext context, IAPProductStatus status) builder;

  const IAPBuilder({
    this.product = IAPProductType.paidFeatures,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      IAPProducts.productOf(context, IAPProductType.paidFeatures)?.status ??
          IAPProductStatus.pending,
    );
  }
}
