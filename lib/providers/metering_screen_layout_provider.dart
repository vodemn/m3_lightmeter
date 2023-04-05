import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:provider/provider.dart';

class MeteringScreenLayoutProvider extends StatefulWidget {
  final Widget child;

  const MeteringScreenLayoutProvider({required this.child, super.key});

  static MeteringScreenLayoutProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<MeteringScreenLayoutProviderState>()!;
  }

  @override
  State<MeteringScreenLayoutProvider> createState() => MeteringScreenLayoutProviderState();
}

class MeteringScreenLayoutProviderState extends State<MeteringScreenLayoutProvider> {
  late final MeteringScreenLayoutConfig _config =
      context.read<UserPreferencesService>().meteringScreenLayout;

  @override
  Widget build(BuildContext context) {
    return MeteringScreenLayout(
      config: MeteringScreenLayoutConfig.from(_config),
      child: widget.child,
    );
  }

  void updateFeatures(MeteringScreenLayoutConfig config) {
    setState(() {
      config.forEach((key, value) {
        _config.update(
          key,
          (_) => value,
          ifAbsent: () => value,
        );
      });
    });
    context.read<UserPreferencesService>().meteringScreenLayout = _config;
  }
}

class MeteringScreenLayout extends InheritedModel<MeteringScreenLayoutFeature> {
  final MeteringScreenLayoutConfig config;

  const MeteringScreenLayout({
    required this.config,
    required super.child,
    super.key,
  });

  static MeteringScreenLayoutConfig of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<MeteringScreenLayout>()!.config;
    } else {
      return context.findAncestorWidgetOfExactType<MeteringScreenLayout>()!.config;
    }
  }

  static bool featureStatusOf(BuildContext context, MeteringScreenLayoutFeature feature) {
    return InheritedModel.inheritFrom<MeteringScreenLayout>(context, aspect: feature)!
        .config[feature]!;
  }

  @override
  bool updateShouldNotify(MeteringScreenLayout oldWidget) => true;

  @override
  bool updateShouldNotifyDependent(
    MeteringScreenLayout oldWidget,
    Set<MeteringScreenLayoutFeature> dependencies,
  ) {
    for (final dependecy in dependencies) {
      if (oldWidget.config[dependecy] != config[dependecy]) {
        return true;
      }
    }
    return false;
  }
}
