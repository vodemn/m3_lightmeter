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
      lifetime: IAPProduct(
        storeId: '',
        type: PurchaseType.lifetime,
        price: '0.0\$',
      ),
      yearly: IAPProduct(
        storeId: '',
        type: PurchaseType.yearly,
        price: '0.0\$',
      ),
      monthly: IAPProduct(
        storeId: '',
        type: PurchaseType.monthly,
        price: '0.0\$',
      ),
      child: widget.child,
    );
  }

  Future<List<IAPProduct>> fetchProducts() async {
    return [];
  }

  Future<bool> buyPro(IAPProduct product) async {
    return false;
  }

  Future<bool> restorePurchases() async {
    return false;
  }

  Future<bool> checkIsPro() async {
    return false;
  }
}

class IAPProducts extends InheritedWidget {
  final IAPProduct? lifetime;
  final IAPProduct? yearly;
  final IAPProduct? monthly;
  final bool _isPro;

  const IAPProducts({
    this.lifetime,
    this.yearly,
    this.monthly,
    required bool isPro,
    required super.child,
    super.key,
  }) : _isPro = isPro;

  static IAPProducts of(BuildContext context) {
    return context.getInheritedWidgetOfExactType<IAPProducts>()!;
  }

  static bool isPro(BuildContext context, {bool listen = true}) {
    return (listen
                ? context.dependOnInheritedWidgetOfExactType<IAPProducts>()
                : context.getInheritedWidgetOfExactType<IAPProducts>())
            ?._isPro ==
        true;
  }

  bool get hasSubscriptions => yearly != null || monthly != null;

  @override
  bool updateShouldNotify(IAPProducts oldWidget) => oldWidget._isPro != _isPro;
}
