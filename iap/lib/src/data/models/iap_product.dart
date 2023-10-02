enum IAPProductStatus {
  purchasable,
  pending,
  purchased,
}

enum IAPProductType { paidFeatures }

class IAPProduct {
  final String storeId;
  final IAPProductStatus status;

  const IAPProduct({
    required this.storeId,
    this.status = IAPProductStatus.purchasable,
  });

  IAPProduct copyWith({IAPProductStatus? status}) => IAPProduct(
        storeId: storeId,
        status: status ?? this.status,
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
