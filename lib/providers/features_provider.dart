import 'package:flutter/material.dart';

enum MeteringScreenLayoutFeature { extremeExposurePairs, reciprocity }

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
  final Map<MeteringScreenLayoutFeature, bool> _features = {
    MeteringScreenLayoutFeature.extremeExposurePairs: true,
    MeteringScreenLayoutFeature.reciprocity: true,
  };

  @override
  Widget build(BuildContext context) {
    return MeteringScreenLayout(
      features: _features,
      child: widget.child,
    );
  }

  void setFeature(MeteringScreenLayoutFeature feature, {required bool enabled}) {
    setState(() {
      _features.update(
        feature,
        (_) => enabled,
        ifAbsent: () => enabled,
      );
    });
  }
}

class MeteringScreenLayout extends InheritedModel<MeteringScreenLayoutFeature> {
  final Map<MeteringScreenLayoutFeature, bool> features;

  const MeteringScreenLayout({
    required this.features,
    required super.child,
    super.key,
  });

  static bool of(BuildContext context, MeteringScreenLayoutFeature feature, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<MeteringScreenLayout>()!.features[feature]!;
    } else {
      return context.findAncestorWidgetOfExactType<MeteringScreenLayout>()!.features[feature]!;
    }
  }

  @override
  bool updateShouldNotify(MeteringScreenLayout oldWidget) => true;

  @override
  bool updateShouldNotifyDependent(
    MeteringScreenLayout oldWidget,
    Set<MeteringScreenLayoutFeature> dependencies,
  ) {
    for (final dependecy in dependencies) {
      if (oldWidget.features[dependecy] != features[dependecy]) {
        return true;
      }
    }
    return false;
  }
}
