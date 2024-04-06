import 'package:flutter/material.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

@visibleForTesting
class MockIAPProductsProvider extends StatefulWidget {
  final bool initialyPurchased;
  final Widget child;

  const MockIAPProductsProvider({this.initialyPurchased = true, required this.child, super.key});

  static MockIAPProductsProviderState of(BuildContext context) => MockIAPProductsProvider.maybeOf(context)!;

  static MockIAPProductsProviderState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<MockIAPProductsProviderState>();
  }

  @override
  State<MockIAPProductsProvider> createState() => MockIAPProductsProviderState();
}

class MockIAPProductsProviderState extends State<MockIAPProductsProvider> {
  late bool _purchased = widget.initialyPurchased;
  @override
  Widget build(BuildContext context) {
    return IAPProducts(
      products: List.from([
        IAPProduct(
          storeId: IAPProductType.paidFeatures.storeId,
          status: _purchased ? IAPProductStatus.purchased : IAPProductStatus.purchasable,
        ),
      ]),
      child: widget.child,
    );
  }

  void buy() {
    _purchased = true;
    setState(() {});
  }

  void clearPurchases() {
    _purchased = false;
    setState(() {});
  }
}
