enum IAPProductStatus {
  purchasable,
  pending,
  purchased,
}

enum IAPProductType { paidFeatures }

class IAPProduct {
  final String storeId;
  final IAPProductStatus status;
  final String price;

  const IAPProduct({
    required this.storeId,
    this.status = IAPProductStatus.purchasable,
    required this.price,
  });

  IAPProduct copyWith({IAPProductStatus? status}) => IAPProduct(
        storeId: storeId,
        status: status ?? this.status,
        price: price,
      );
}

extension IAPProductTypeExtension on IAPProductType {
  String get storeId {
    switch (this) {
      case IAPProductType.paidFeatures:
        return "";
    }
  }
}
