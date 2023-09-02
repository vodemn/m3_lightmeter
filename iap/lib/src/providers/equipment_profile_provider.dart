import 'package:flutter/material.dart';
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
      profiles: const [_defaultProfile],
      selected: _defaultProfile,
      child: widget.child,
    );
  }

  void setProfile(EquipmentProfile data) {}

  void addProfile(String name) {}

  void updateProdile(EquipmentProfile data) {}

  void deleteProfile(EquipmentProfile data) {}
}

enum EquipmentProfilesAspect { list, selected }

class EquipmentProfiles extends InheritedModel<EquipmentProfilesAspect> {
  const EquipmentProfiles({
    super.key,
    required this.profiles,
    required this.selected,
    required super.child,
  });

  final List<EquipmentProfile> profiles;
  final EquipmentProfile selected;

  static List<EquipmentProfile> of(BuildContext context) {
    return InheritedModel.inheritFrom<EquipmentProfiles>(
      context,
      aspect: EquipmentProfilesAspect.list,
    )!
        .profiles;
  }

  static EquipmentProfile selectedOf(BuildContext context) {
    return InheritedModel.inheritFrom<EquipmentProfiles>(
      context,
      aspect: EquipmentProfilesAspect.selected,
    )!
        .selected;
  }

  @override
  bool updateShouldNotify(EquipmentProfiles oldWidget) => false;

  @override
  bool updateShouldNotifyDependent(EquipmentProfiles oldWidget, Set<EquipmentProfilesAspect> dependencies) => false;
}
