import 'package:flutter/material.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
  static const EquipmentProfileData _defaultProfile = EquipmentProfileData(
    id: '',
    name: '',
    apertureValues: apertureValues,
    ndValues: ndValues,
    shutterSpeedValues: shutterSpeedValues,
    isoValues: isoValues,
  );

  List<EquipmentProfileData> _customProfiles = [];
  String _selectedId = '';

  EquipmentProfileData get _selectedProfile => _customProfiles.firstWhere(
        (e) => e.id == _selectedId,
        orElse: () {
          context.read<UserPreferencesService>().selectedEquipmentProfileId = _defaultProfile.id;
          return _defaultProfile;
        },
      );

  @override
  void initState() {
    super.initState();
    _selectedId = context.read<UserPreferencesService>().selectedEquipmentProfileId;
    _customProfiles = context.read<UserPreferencesService>().equipmentProfiles;
  }

  @override
  Widget build(BuildContext context) {
    return EquipmentProfiles(
      profiles: [_defaultProfile] + _customProfiles,
      child: EquipmentProfile(
        data: _selectedProfile,
        child: widget.child,
      ),
    );
  }

  void setProfile(EquipmentProfileData data) {
    setState(() {
      _selectedId = data.id;
    });
    context.read<UserPreferencesService>().selectedEquipmentProfileId = _selectedProfile.id;
  }

  /// Creates a default equipment profile
  void addProfile(String name) {
    _customProfiles.add(EquipmentProfileData(
      id: const Uuid().v1(),
      name: name,
      apertureValues: apertureValues,
      ndValues: ndValues,
      shutterSpeedValues: shutterSpeedValues,
      isoValues: isoValues,
    ));
    _refreshSavedProfiles();
  }

  void updateProdile(EquipmentProfileData data) {
    final indexToUpdate = _customProfiles.indexWhere((element) => element.id == data.id);
    if (indexToUpdate >= 0) {
      _customProfiles[indexToUpdate] = data;
      _refreshSavedProfiles();
    }
  }

  void deleteProfile(EquipmentProfileData data) {
    _customProfiles.remove(data);
    _refreshSavedProfiles();
  }

  void _refreshSavedProfiles() {
    context.read<UserPreferencesService>().equipmentProfiles = _customProfiles;
    setState(() {});
  }
}

class EquipmentProfiles extends InheritedWidget {
  final List<EquipmentProfileData> profiles;

  const EquipmentProfiles({
    required this.profiles,
    required super.child,
    super.key,
  });

  static List<EquipmentProfileData> of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<EquipmentProfiles>()!.profiles;
    } else {
      return context.findAncestorWidgetOfExactType<EquipmentProfiles>()!.profiles;
    }
  }

  @override
  bool updateShouldNotify(EquipmentProfiles oldWidget) => true;
}

class EquipmentProfile extends InheritedWidget {
  final EquipmentProfileData data;

  const EquipmentProfile({
    required this.data,
    required super.child,
    super.key,
  });

  static EquipmentProfileData of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<EquipmentProfile>()!.data;
    } else {
      return context.findAncestorWidgetOfExactType<EquipmentProfile>()!.data;
    }
  }

  @override
  bool updateShouldNotify(EquipmentProfile oldWidget) => true;
}
