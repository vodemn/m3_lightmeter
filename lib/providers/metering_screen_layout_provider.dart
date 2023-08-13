import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/providers/service_provider.dart';
import 'package:lightmeter/utils/inherited_generics.dart';

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
      ServiceProvider.userPreferencesServiceOf(context).meteringScreenLayout;

  @override
  Widget build(BuildContext context) {
    return InheritedModelBase<MeteringScreenLayoutFeature, bool>(
      data: MeteringScreenLayoutConfig.from(_config),
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
    ServiceProvider.userPreferencesServiceOf(context).meteringScreenLayout = _config;
  }
}

typedef _MeteringScreenLayoutModel = InheritedModelBase<MeteringScreenLayoutFeature, bool>;

extension MeteringScreenLayout on InheritedModelBase<MeteringScreenLayoutFeature, bool> {
  static MeteringScreenLayoutConfig of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<_MeteringScreenLayoutModel>()!.data;
    } else {
      return context.findAncestorWidgetOfExactType<_MeteringScreenLayoutModel>()!.data;
    }
  }

  static bool featureOf(BuildContext context, MeteringScreenLayoutFeature aspect) {
    return InheritedModel.inheritFrom<_MeteringScreenLayoutModel>(context, aspect: aspect)!
        .data[aspect]!;
  }
}
