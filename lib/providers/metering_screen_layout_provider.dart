import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/utils/inherited_generics.dart';
import 'package:provider/provider.dart';

typedef MeteringScreenLayout = InheritedModelBase<MeteringScreenLayoutFeature, bool>;

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
    context.read<UserPreferencesService>().meteringScreenLayout = _config;
  }
}
