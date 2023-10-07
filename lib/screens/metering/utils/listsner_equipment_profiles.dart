import 'package:flutter/material.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class EquipmentProfileListener extends StatefulWidget {
  final ValueChanged<EquipmentProfile> onDidChangeDependencies;
  final Widget child;

  const EquipmentProfileListener({
    required this.onDidChangeDependencies,
    required this.child,
    super.key,
  });

  @override
  State<EquipmentProfileListener> createState() => _EquipmentProfileListenerState();
}

class _EquipmentProfileListenerState extends State<EquipmentProfileListener> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.onDidChangeDependencies(EquipmentProfiles.selectedOf(context));
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
