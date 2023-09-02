enum IAPProductStatus {
  purchasable,
  pending,
  purchased,
}

enum IAPProductType { paidFeatures }

abstract class IAPProduct {
  const IAPProduct._();

  IAPProductStatus get status => IAPProductStatus.purchasable;
}
