import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/providers/service_providers.dart';
import 'package:lightmeter/utils/inherited_generics.dart';

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
    final evSourceType = ServiceProviders.userPreferencesServiceOf(context).evSourceType;
    valueListenable = ValueNotifier(
      evSourceType == EvSourceType.sensor && !ServiceProviders.environmentOf(context).hasLightSensor
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
      builder: (_, value, child) => InheritedWidgetBase<EvSourceType>(
        data: value,
        child: child!,
      ),
      child: widget.child,
    );
  }

  void toggleType() {
    switch (valueListenable.value) {
      case EvSourceType.camera:
        if (ServiceProviders.environmentOf(context).hasLightSensor) {
          valueListenable.value = EvSourceType.sensor;
        }
      case EvSourceType.sensor:
        valueListenable.value = EvSourceType.camera;
    }
    ServiceProviders.userPreferencesServiceOf(context).evSourceType = valueListenable.value;
  }
}
