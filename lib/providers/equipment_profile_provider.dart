import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lightmeter/utils/context_utils.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class EquipmentProfilesProvider extends StatefulWidget {
  static const EquipmentProfile defaultProfile = EquipmentProfile(
    id: '',
    name: '',
    apertureValues: ApertureValue.values,
    ndValues: NdValue.values,
    shutterSpeedValues: ShutterSpeedValue.values,
    isoValues: IsoValue.values,
  );

  final IapStorageService storageService;
  final VoidCallback? onInitialized;
  final Widget child;

  const EquipmentProfilesProvider({
    required this.storageService,
    this.onInitialized,
    required this.child,
    super.key,
  });

  static EquipmentProfilesProviderState of(BuildContext context) {
    return context.findAncestorStateOfType<EquipmentProfilesProviderState>()!;
  }

  @override
  State<EquipmentProfilesProvider> createState() => EquipmentProfilesProviderState();
}

class EquipmentProfilesProviderState extends State<EquipmentProfilesProvider> {
  final TogglableMap<EquipmentProfile> _customProfiles = {};
  String _selectedId = '';

  EquipmentProfile get _selectedProfile =>
      _customProfiles[_selectedId]?.value ?? EquipmentProfilesProvider.defaultProfile;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return EquipmentProfiles(
      profiles: context.isPro ? _customProfiles : {},
      selected: context.isPro ? _selectedProfile : EquipmentProfilesProvider.defaultProfile,
      child: widget.child,
    );
  }

  Future<void> _init() async {
    _selectedId = widget.storageService.selectedEquipmentProfileId;
    _customProfiles.addAll(await widget.storageService.getEquipmentProfiles());
    _discardSelectedIfNotIncluded();
    if (mounted) setState(() {});
    widget.onInitialized?.call();
  }

  Future<void> addProfile(EquipmentProfile profile) async {
    await widget.storageService.addEquipmentProfile(profile);
    _customProfiles[profile.id] = (value: profile, isUsed: true);
    setState(() {});
  }

  Future<void> updateProfile(EquipmentProfile profile) async {
    final oldProfile = _customProfiles[profile.id]!.value;
    await widget.storageService.updateEquipmentProfile(
      id: profile.id,
      name: oldProfile.name != profile.name ? profile.name : null,
      apertureValues: oldProfile.apertureValues != profile.apertureValues ? profile.apertureValues : null,
      shutterSpeedValues:
          oldProfile.shutterSpeedValues != profile.shutterSpeedValues ? profile.shutterSpeedValues : null,
      isoValues: oldProfile.isoValues != profile.isoValues ? profile.isoValues : null,
      ndValues: oldProfile.ndValues != profile.ndValues ? profile.ndValues : null,
      lensZoom: oldProfile.lensZoom != profile.lensZoom ? profile.lensZoom : null,
    );
    _customProfiles[profile.id] = (value: profile, isUsed: _customProfiles[profile.id]!.isUsed);
    setState(() {});
  }

  Future<void> deleteProfile(EquipmentProfile profile) async {
    await widget.storageService.deleteEquipmentProfile(profile.id);
    if (profile.id == _selectedId) {
      _selectedId = EquipmentProfilesProvider.defaultProfile.id;
      widget.storageService.selectedEquipmentProfileId = EquipmentProfilesProvider.defaultProfile.id;
    }
    _customProfiles.remove(profile.id);
    _discardSelectedIfNotIncluded();
    setState(() {});
  }

  void selectProfile(EquipmentProfile data) {
    if (_selectedId != data.id) {
      setState(() {
        _selectedId = data.id;
      });
      widget.storageService.selectedEquipmentProfileId = _selectedProfile.id;
    }
  }

  Future<void> toggleProfile(EquipmentProfile profile, bool enabled) async {
    if (_customProfiles.containsKey(profile.id)) {
      _customProfiles[profile.id] = (value: profile, isUsed: enabled);
    } else {
      return;
    }
    await widget.storageService.updateEquipmentProfile(id: profile.id, isUsed: enabled);
    _discardSelectedIfNotIncluded();
    setState(() {});
  }

  void _discardSelectedIfNotIncluded() {
    if (_selectedId == EquipmentProfilesProvider.defaultProfile.id) {
      return;
    }
    final isSelectedUsed = _customProfiles[_selectedId]?.isUsed ?? false;
    if (!isSelectedUsed) {
      _selectedId = EquipmentProfilesProvider.defaultProfile.id;
      widget.storageService.selectedEquipmentProfileId = _selectedId;
    }
  }
}

enum _EquipmentProfilesModelAspect {
  profiles,
  profilesInUse,
  selected,
}

class EquipmentProfiles extends InheritedModel<_EquipmentProfilesModelAspect> {
  final TogglableMap<EquipmentProfile> profiles;
  final EquipmentProfile selected;

  const EquipmentProfiles({
    required this.profiles,
    required this.selected,
    required super.child,
  });

  /// _default + profiles create by the user
  static List<EquipmentProfile> of(BuildContext context) {
    final model =
        InheritedModel.inheritFrom<EquipmentProfiles>(context, aspect: _EquipmentProfilesModelAspect.profiles)!;
    return List<EquipmentProfile>.from(
      [
        EquipmentProfilesProvider.defaultProfile,
        ...model.profiles.values.map((p) => p.value),
      ],
    );
  }

  static List<EquipmentProfile> inUseOf(BuildContext context) {
    final model =
        InheritedModel.inheritFrom<EquipmentProfiles>(context, aspect: _EquipmentProfilesModelAspect.profilesInUse)!;
    return List<EquipmentProfile>.from(
      [
        EquipmentProfilesProvider.defaultProfile,
        ...model.profiles.values.where((p) => p.isUsed).map((p) => p.value),
      ],
    );
  }

  static EquipmentProfile selectedOf(BuildContext context) {
    return InheritedModel.inheritFrom<EquipmentProfiles>(context, aspect: _EquipmentProfilesModelAspect.selected)!
        .selected;
  }

  @override
  bool updateShouldNotify(EquipmentProfiles _) => true;

  @override
  bool updateShouldNotifyDependent(EquipmentProfiles oldWidget, Set<_EquipmentProfilesModelAspect> dependencies) {
    return (dependencies.contains(_EquipmentProfilesModelAspect.selected) && oldWidget.selected != selected) ||
        ((dependencies.contains(_EquipmentProfilesModelAspect.profiles) ||
                dependencies.contains(_EquipmentProfilesModelAspect.profilesInUse)) &&
            const DeepCollectionEquality().equals(oldWidget.profiles, profiles));
  }
}
