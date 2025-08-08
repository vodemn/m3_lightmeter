class IAPProduct {
  final String storeId;
  final PurchaseType type;
  final String price;

  IAPProduct({
    required this.storeId,
    required this.type,
    required this.price,
  });
}

enum PurchaseType { monthly, yearly, lifetime }
