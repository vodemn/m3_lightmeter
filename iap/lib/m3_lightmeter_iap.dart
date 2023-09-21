library m3_lightmeter_iap;

import 'package:flutter/material.dart';
import 'package:m3_lightmeter_iap/src/providers/equipment_profile_provider.dart';
import 'package:m3_lightmeter_iap/src/providers/films_provider.dart';
import 'package:m3_lightmeter_iap/src/providers/iap_products_provider.dart';

export 'src/data/models/iap_product.dart';

export 'src/providers/equipment_profile_provider.dart';
export 'src/providers/films_provider.dart';
export 'src/providers/iap_products_provider.dart';

class IAPProviders extends StatelessWidget {
  final Object sharedPreferences;
  final Widget child;

  const IAPProviders({
    required this.sharedPreferences,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IAPProductsProvider(
      child: FilmsProvider(
        child: EquipmentProfileProvider(
          child: child,
        ),
      ),
    );
  }
}
