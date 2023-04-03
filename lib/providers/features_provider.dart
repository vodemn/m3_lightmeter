import 'package:flutter/material.dart';

enum MeteringScreenLayoutFeature { extremeExposurePairs, filmPicker }

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
    MeteringScreenLayoutFeature.filmPicker: true,
  };

  @override
  Widget build(BuildContext context) {
    return MeteringScreenLayout(
      features: Map<MeteringScreenLayoutFeature, bool>.from(_features),
      child: widget.child,
    );
  }

  void updateFeatures(Map<MeteringScreenLayoutFeature, bool> features) {
    setState(() {
      features.forEach((key, value) {
        _features.update(
          key,
          (_) => value,
          ifAbsent: () => value,
        );
      });
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

  static Map<MeteringScreenLayoutFeature, bool> of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<MeteringScreenLayout>()!.features;
    } else {
      return context.findAncestorWidgetOfExactType<MeteringScreenLayout>()!.features;
    }
  }

  static bool featureStatusOf(BuildContext context, MeteringScreenLayoutFeature feature) {
    return InheritedModel.inheritFrom<MeteringScreenLayout>(context, aspect: feature)!
        .features[feature]!;
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
