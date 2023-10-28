import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/feature.dart';
import 'package:lightmeter/providers/services_provider.dart';

class RemoteConfig extends InheritedWidget {
  const RemoteConfig({
    super.key,
    required super.child,
  });

  static bool isEnabled(BuildContext context, Feature feature) {
    return ServicesProvider.of(context).remoteConfigService.isEnabled(feature);
  }

  @override
  bool updateShouldNotify(RemoteConfig oldWidget) => true;
}
