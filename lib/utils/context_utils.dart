import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';

extension BuildContextUtils on BuildContext {
  bool meteringFeature(MeteringScreenLayoutFeature feature) {
    return UserPreferencesProvider.meteringScreenFeatureOf(this, feature);
  }

  bool get isPro => IAPProducts.isPurchased(this, IAPProductType.paidFeatures);
}
