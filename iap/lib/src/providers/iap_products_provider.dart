import 'package:flutter/material.dart';
import 'package:m3_lightmeter_iap/src/data/models/iap_product.dart';

class IAPProductsProvider extends StatefulWidget {
  final Widget child;

  const IAPProductsProvider({required this.child, super.key});

  static IAPProductsProviderState of(BuildContext context) => IAPProductsProvider.maybeOf(context)!;

  static IAPProductsProviderState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<IAPProductsProviderState>();
  }

  @override
  State<IAPProductsProvider> createState() => IAPProductsProviderState();
}

class IAPProductsProviderState extends State<IAPProductsProvider> {
  @override
  Widget build(BuildContext context) {
    return IAPProducts(
      isPro: true,
      child: widget.child,
    );
  }

  Future<void> buy(IAPProductType type) async {}

  Future<void> restorePurchases() async {}
}

class IAPProducts extends InheritedModel<IAPProductType> {
  final List<IAPProduct> products;

  const IAPProducts({
    required this.products,
    required super.child,
    super.key,
  });

  static IAPProduct? productOf(BuildContext context, IAPProductType type) {
    final IAPProducts? result = InheritedModel.inheritFrom<IAPProducts>(context, aspect: type);
    return result!._findProduct(type);
  }

  static bool isPurchased(BuildContext context, IAPProductType type) {
    final IAPProducts? result = InheritedModel.inheritFrom<IAPProducts>(context, aspect: type);
    return result!._findProduct(type)?.status == IAPProductStatus.purchased;
  }

  @override
  bool updateShouldNotify(IAPProducts oldWidget) => true;

  @override
  bool updateShouldNotifyDependent(IAPProducts oldWidget, Set<IAPProductType> dependencies) => true;

  IAPProduct? _findProduct(IAPProductType type) {
    try {
      return products.firstWhere((element) => element.storeId == type.storeId);
    } catch (_) {
      return null;
    }
  }
}
