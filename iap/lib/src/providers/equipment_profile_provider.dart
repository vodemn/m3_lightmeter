import 'package:flutter/material.dart';
import 'package:m3_lightmeter_iap/src/providers/selectable_provider.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class EquipmentProfileProvider extends StatefulWidget {
  final Widget child;

  const EquipmentProfileProvider({required this.child, super.key});

  static EquipmentProfileProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<EquipmentProfileProviderState>()!;
  }

  @override
  State<EquipmentProfileProvider> createState() => EquipmentProfileProviderState();
}

class EquipmentProfileProviderState extends State<EquipmentProfileProvider> {
  static const EquipmentProfile _defaultProfile = EquipmentProfile(
    id: '',
    name: '',
    apertureValues: ApertureValue.values,
    ndValues: NdValue.values,
    shutterSpeedValues: ShutterSpeedValue.values,
    isoValues: IsoValue.values,
  );

  @override
  Widget build(BuildContext context) {
    return EquipmentProfiles(
      values: const [_defaultProfile],
      selected: _defaultProfile,
      child: widget.child,
    );
  }

  void setProfile(EquipmentProfile data) {}

  void addProfile(String name) {}

  void updateProdile(EquipmentProfile data) {}

  void deleteProfile(EquipmentProfile data) {}
}

class EquipmentProfiles extends SelectableInheritedModel<EquipmentProfile> {
  const EquipmentProfiles({
    super.key,
    required super.values,
    required super.selected,
    required super.child,
  });

  static List<EquipmentProfile> of(BuildContext context) {
    return InheritedModel.inheritFrom<EquipmentProfiles>(context, aspect: SelectableAspect.list)!.values;
  }

  static EquipmentProfile selectedOf(BuildContext context) {
    return InheritedModel.inheritFrom<EquipmentProfiles>(context, aspect: SelectableAspect.selected)!.selected;
  }
}
