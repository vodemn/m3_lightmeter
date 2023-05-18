import 'package:flutter/material.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/utils/inherited_generics.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:uuid/uuid.dart';

typedef EquipmentProfiles = List<EquipmentProfileData>;
typedef EquipmentProfile = EquipmentProfileData;

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
    apertureValues: ApertureValue.values,
    ndValues: NdValue.values,
    shutterSpeedValues: ShutterSpeedValue.values,
    isoValues: IsoValue.values,
  );

  List<EquipmentProfileData> _customProfiles = [];
  String _selectedId = '';

  EquipmentProfileData get _selectedProfile => _customProfiles.firstWhere(
        (e) => e.id == _selectedId,
        orElse: () {
          context.get<UserPreferencesService>().selectedEquipmentProfileId = _defaultProfile.id;
          return _defaultProfile;
        },
      );

  @override
  void initState() {
    super.initState();
    _selectedId = context.get<UserPreferencesService>().selectedEquipmentProfileId;
    _customProfiles = context.get<UserPreferencesService>().equipmentProfiles;
  }

  @override
  Widget build(BuildContext context) {
    return InheritedWidgetBase<List<EquipmentProfileData>>(
      data: [_defaultProfile] + _customProfiles,
      child: InheritedWidgetBase<EquipmentProfileData>(
        data: _selectedProfile,
        child: widget.child,
      ),
    );
  }

  void setProfile(EquipmentProfileData data) {
    setState(() {
      _selectedId = data.id;
    });
    context.get<UserPreferencesService>().selectedEquipmentProfileId = _selectedProfile.id;
  }

  /// Creates a default equipment profile
  void addProfile(String name) {
    _customProfiles.add(
      EquipmentProfileData(
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
    context.get<UserPreferencesService>().equipmentProfiles = _customProfiles;
    setState(() {});
  }
}
