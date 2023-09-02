import 'package:flutter/material.dart';
import 'package:m3_lightmeter_iap/src/data/models/iap_product.dart';

class IAPProductsProvider extends StatefulWidget {
  final Widget child;

  const IAPProductsProvider({required this.child, super.key});

  static IAPProductsProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<IAPProductsProviderState>()!;
  }

  @override
  State<IAPProductsProvider> createState() => IAPProductsProviderState();
}

class IAPProductsProviderState extends State<IAPProductsProvider> {
  @override
  Widget build(BuildContext context) {
    return IAPProducts(
      products: const [],
      child: widget.child,
    );
  }

  Future<void> buy(IAPProductType type) async {}
}

class IAPProducts extends InheritedModel<IAPProductType> {
  final List<IAPProduct> products;

  const IAPProducts({
    required this.products,
    required super.child,
    super.key,
  });

  static IAPProduct? of(BuildContext context, IAPProductType type) => null;

  static bool isPurchased(BuildContext context, IAPProductType type) => false;

  @override
  bool updateShouldNotify(IAPProducts oldWidget) => false;

  @override
  bool updateShouldNotifyDependent(covariant IAPProducts oldWidget, Set<IAPProductType> dependencies) => false;
}
