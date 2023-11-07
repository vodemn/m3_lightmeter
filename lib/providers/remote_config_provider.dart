import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/feature.dart';
import 'package:lightmeter/data/remote_config_service.dart';

class RemoteConfigProvider extends StatefulWidget {
  final RemoteConfigService remoteConfigService;
  final Widget child;

  const RemoteConfigProvider({
    required this.remoteConfigService,
    required this.child,
    super.key,
  });

  @override
  State<RemoteConfigProvider> createState() => RemoteConfigProviderState();
}

class RemoteConfigProviderState extends State<RemoteConfigProvider> {
  late final Map<Feature, dynamic> _config = widget.remoteConfigService.getAll();
  late final StreamSubscription<Set<Feature>> _updatesSubscription;

  @override
  void initState() {
    super.initState();
    _updatesSubscription = widget.remoteConfigService.onConfigUpdated().listen(
          _updateFeatures,
          onError: (e) => log(e.toString()),
        );
  }

  @override
  void dispose() {
    _updatesSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RemoteConfig(
      config: _config,
      child: widget.child,
    );
  }

  void _updateFeatures(Set<Feature> updatedFeatures) {
    for (final feature in updatedFeatures) {
      _config[feature] = widget.remoteConfigService.getValue(feature);
    }
    setState(() {});
  }
}

class RemoteConfig extends InheritedModel<Feature> {
  final Map<Feature, dynamic> _config;

  const RemoteConfig({
    super.key,
    required Map<Feature, dynamic> config,
    required super.child,
  }) : _config = config;

  static bool isEnabled(BuildContext context, Feature feature) {
    return InheritedModel.inheritFrom<RemoteConfig>(context)!._config[feature] as bool;
  }

  @override
  bool updateShouldNotify(RemoteConfig oldWidget) => true;

  @override
  bool updateShouldNotifyDependent(RemoteConfig oldWidget, Set<Feature> features) {
    for (final feature in features) {
      if (oldWidget._config[feature] != _config[feature]) {
        return true;
      }
    }
    return false;
  }
}
