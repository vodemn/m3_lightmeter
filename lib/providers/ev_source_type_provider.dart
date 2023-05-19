import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/environment.dart';
import 'package:provider/provider.dart';

class EvSourceTypeProvider extends StatefulWidget {
  final Widget child;

  const EvSourceTypeProvider({required this.child, super.key});

  static EvSourceTypeProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<EvSourceTypeProviderState>()!;
  }

  @override
  State<EvSourceTypeProvider> createState() => EvSourceTypeProviderState();
}

class EvSourceTypeProviderState extends State<EvSourceTypeProvider> {
  late final ValueNotifier<EvSourceType> valueListenable;

  @override
  void initState() {
    super.initState();
    final evSourceType = context.read<UserPreferencesService>().evSourceType;
    valueListenable = ValueNotifier(
      evSourceType == EvSourceType.sensor && !context.read<Environment>().hasLightSensor
          ? EvSourceType.camera
          : evSourceType,
    );
  }

  @override
  void dispose() {
    valueListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (_, value, child) => Provider.value(
        value: value,
        child: child,
      ),
      child: widget.child,
    );
  }

  void toggleType() {
    switch (valueListenable.value) {
      case EvSourceType.camera:
        if (context.read<Environment>().hasLightSensor) {
          valueListenable.value = EvSourceType.sensor;
        }
      case EvSourceType.sensor:
        valueListenable.value = EvSourceType.camera;
    }
    context.read<UserPreferencesService>().evSourceType = valueListenable.value;
  }
}
