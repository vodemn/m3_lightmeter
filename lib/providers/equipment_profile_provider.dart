import 'package:flutter/material.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:uuid/uuid.dart';

// TODO(@vodemn): This will be removed in #89
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

  List<EquipmentProfile> _customProfiles = [];
  String _selectedId = '';

  EquipmentProfile get _selectedProfile => _customProfiles.firstWhere(
        (e) => e.id == _selectedId,
        orElse: () {
          ServicesProvider.userPreferencesServiceOf(context).selectedEquipmentProfileId =
              _defaultProfile.id;
          return _defaultProfile;
        },
      );

  @override
  void initState() {
    super.initState();
    _selectedId = ServicesProvider.userPreferencesServiceOf(context).selectedEquipmentProfileId;
    _customProfiles = ServicesProvider.userPreferencesServiceOf(context).equipmentProfiles;
  }

  @override
  Widget build(BuildContext context) {
    return EquipmentProfiles(
      profiles: [_defaultProfile] + _customProfiles,
      selected: _selectedProfile,
      child: widget.child,
    );
  }

  void setProfile(EquipmentProfile data) {
    setState(() {
      _selectedId = data.id;
    });
    ServicesProvider.userPreferencesServiceOf(context).selectedEquipmentProfileId =
        _selectedProfile.id;
  }

  /// Creates a default equipment profile
  void addProfile(String name) {
    _customProfiles.add(
      EquipmentProfile(
        id: const Uuid().v1(),
        name: name,
        apertureValues: ApertureValue.values,
        ndValues: NdValue.values,
        shutterSpeedValues: ShutterSpeedValue.values,
        isoValues: IsoValue.values,
      ),
    );
    _refreshSavedProfiles();
  }

  void updateProdile(EquipmentProfile data) {
    final indexToUpdate = _customProfiles.indexWhere((element) => element.id == data.id);
    if (indexToUpdate >= 0) {
      _customProfiles[indexToUpdate] = data;
      _refreshSavedProfiles();
    }
  }

  void deleteProfile(EquipmentProfile data) {
    _customProfiles.remove(data);
    _refreshSavedProfiles();
  }

  void _refreshSavedProfiles() {
    ServicesProvider.userPreferencesServiceOf(context).equipmentProfiles = _customProfiles;
    setState(() {});
  }
}

// Copied from #89
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
  bool updateShouldNotifyDependent(
          EquipmentProfiles oldWidget, Set<EquipmentProfilesAspect> dependencies,) =>
      false;
}
