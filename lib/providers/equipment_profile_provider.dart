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
  final List<EquipmentProfileData> _profiles = [];

  late EquipmentProfileData _selectedProfile = _profiles.isNotEmpty
      ? _profiles.first
      : const EquipmentProfileData(
          id: 'default',
          name: '',
          apertureValues: apertureValues,
          ndValues: ndValues,
          shutterSpeedValues: shutterSpeedValues,
          isoValues: isoValues,
        );

  @override
  Widget build(BuildContext context) {
    return EquipmentProfiles(
      profiles: _profiles,
      child: EquipmentProfile(
        data: _selectedProfile,
        child: widget.child,
      ),
    );
  }

  void setProfile(EquipmentProfileData data) {
    setState(() {
      _selectedProfile = data;
    });
  }

  void addProfile(EquipmentProfileData data) {}

  void updateProdile(EquipmentProfileData data) {}

  void deleteProfile(EquipmentProfileData data) {}
}

class EquipmentProfiles extends InheritedWidget {
  final List<EquipmentProfileData> profiles;

  const EquipmentProfiles({
    required this.profiles,
    required super.child,
    super.key,
  });

  static List<EquipmentProfileData>? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EquipmentProfiles>()?.profiles;
  }

  @override
  bool updateShouldNotify(EquipmentProfiles oldWidget) => true;
}

class EquipmentProfile extends InheritedWidget {
  final EquipmentProfileData? data;

  const EquipmentProfile({
    required this.data,
    required super.child,
    super.key,
  });

  static EquipmentProfileData? of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<EquipmentProfile>()?.data;
    } else {
      return context.findAncestorWidgetOfExactType<EquipmentProfile>()?.data;
    }
  }

  @override
  bool updateShouldNotify(EquipmentProfile oldWidget) => true;
}
