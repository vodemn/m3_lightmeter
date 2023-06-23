import 'package:flutter/material.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/utils/inherited_generics.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class StopTypeProvider extends StatefulWidget {
  final Widget child;

  const StopTypeProvider({required this.child, super.key});

  static StopTypeProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<StopTypeProviderState>()!;
  }

  @override
  State<StopTypeProvider> createState() => StopTypeProviderState();
}

class StopTypeProviderState extends State<StopTypeProvider> {
  late StopType _stopType;

  @override
  void initState() {
    super.initState();
    _stopType = context.get<UserPreferencesService>().stopType;
  }

  @override
  Widget build(BuildContext context) {
    return InheritedWidgetBase<StopType>(
      data: _stopType,
      child: widget.child,
    );
  }

  void set(StopType type) {
    setState(() {
      _stopType = type;
    });
    context.get<UserPreferencesService>().stopType = type;
  }
}
