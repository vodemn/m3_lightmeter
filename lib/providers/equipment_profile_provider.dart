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
  final TogglableMap<IEquipmentProfile> _profiles = {};
  String _selectedId = '';

  IEquipmentProfile get _selectedProfile => _profiles[_selectedId]?.value ?? EquipmentProfilesProvider.defaultProfile;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return EquipmentProfiles(
      profiles: context.isPro ? _profiles : {},
      selected: context.isPro ? _selectedProfile : EquipmentProfilesProvider.defaultProfile,
      child: widget.child,
    );
  }

  Future<void> _init() async {
    _selectedId = widget.storageService.selectedEquipmentProfileId;
    _profiles
      ..addAll(await widget.storageService.getEquipmentProfiles())
      ..addAll(await widget.storageService.getPinholeEquipmentProfiles());
    _sortProfiles();
    _discardSelectedIfNotIncluded();
    if (mounted) setState(() {});
    widget.onInitialized?.call();
  }

  Future<void> addProfile(IEquipmentProfile profile) async {
    switch (profile) {
      case final PinholeEquipmentProfile profile:
        await widget.storageService.addPinholeEquipmentProfile(profile);
      case final EquipmentProfile profile:
        await widget.storageService.addEquipmentProfile(profile);
    }
    _profiles[profile.id] = (value: profile, isUsed: true);
    _sortProfiles();
    setState(() {});
  }

  Future<void> updateProfile(IEquipmentProfile profile) async {
    switch (profile) {
      case final PinholeEquipmentProfile profile:
        final oldProfile = _profiles[profile.id]!.value as PinholeEquipmentProfile;
        await widget.storageService.updatePinholeEquipmentProfile(
          id: profile.id,
          name: profile.name,
          aperture: oldProfile.aperture.changedOrNull(profile.aperture),
          isoValues: oldProfile.isoValues.changedOrNull(profile.isoValues),
          ndValues: oldProfile.ndValues.changedOrNull(profile.ndValues),
          lensZoom: oldProfile.lensZoom.changedOrNull(profile.lensZoom),
          exposureOffset: oldProfile.exposureOffset.changedOrNull(profile.exposureOffset),
        );
      case final EquipmentProfile profile:
        final oldProfile = _profiles[profile.id]!.value as EquipmentProfile;
        await widget.storageService.updateEquipmentProfile(
          id: profile.id,
          name: oldProfile.name.changedOrNull(profile.name),
          apertureValues: oldProfile.apertureValues.changedOrNull(profile.apertureValues),
          shutterSpeedValues: oldProfile.shutterSpeedValues.changedOrNull(profile.shutterSpeedValues),
          isoValues: oldProfile.isoValues.changedOrNull(profile.isoValues),
          ndValues: oldProfile.ndValues.changedOrNull(profile.ndValues),
          lensZoom: oldProfile.lensZoom.changedOrNull(profile.lensZoom),
          exposureOffset: oldProfile.exposureOffset.changedOrNull(profile.exposureOffset),
        );
    }
    final bool shouldSort = _profiles[profile.id]!.value.name != profile.name;
    _profiles[profile.id] = (value: profile, isUsed: _profiles[profile.id]!.isUsed);
    if (shouldSort) _sortProfiles();
    setState(() {});
  }

  Future<void> deleteProfile(IEquipmentProfile profile) async {
    if (profile.id == _selectedId) {
      _selectedId = EquipmentProfilesProvider.defaultProfile.id;
      widget.storageService.selectedEquipmentProfileId = EquipmentProfilesProvider.defaultProfile.id;
    }
    switch (profile) {
      case final PinholeEquipmentProfile profile:
        await widget.storageService.deletePinholeEquipmentProfile(profile.id);
      case final EquipmentProfile profile:
        await widget.storageService.deleteEquipmentProfile(profile.id);
    }
    _profiles.remove(profile.id);
    _discardSelectedIfNotIncluded();
    setState(() {});
  }

  void selectProfile(String id) {
    if (_selectedId != id) {
      setState(() {
        _selectedId = id;
      });
      widget.storageService.selectedEquipmentProfileId = _selectedProfile.id;
    }
  }

  Future<void> toggleProfile(String id, bool enabled) async {
    if (_profiles.containsKey(id)) {
      _profiles[id] = (value: _profiles[id]!.value, isUsed: enabled);
      await widget.storageService.updateEquipmentProfile(id: id, isUsed: enabled);
    } else {
      return;
    }
    _discardSelectedIfNotIncluded();
    setState(() {});
  }

  void _discardSelectedIfNotIncluded() {
    if (_selectedId == EquipmentProfilesProvider.defaultProfile.id) {
      return;
    }
    final isSelectedUsed = _profiles[_selectedId]?.isUsed ?? false;
    if (!isSelectedUsed) {
      _selectedId = EquipmentProfilesProvider.defaultProfile.id;
      widget.storageService.selectedEquipmentProfileId = _selectedId;
    }
  }

  void _sortProfiles() {
    final sortedByName = _profiles.values.toList(growable: false)
      ..sort((a, b) => a.value.name.toLowerCase().compareTo(b.value.name.toLowerCase()));
    _profiles.clear();
    _profiles.addEntries(sortedByName.map((e) => MapEntry(e.value.id, e)));
  }
}

enum _EquipmentProfilesModelAspect {
  profiles,
  profilesInUse,
  selected,
}

class EquipmentProfiles extends InheritedModel<_EquipmentProfilesModelAspect> {
  final TogglableMap<IEquipmentProfile> profiles;
  final IEquipmentProfile selected;

  const EquipmentProfiles({
    required this.profiles,
    required this.selected,
    required super.child,
  });

  /// _default + profiles create by the user
  static List<IEquipmentProfile> of(BuildContext context) {
    final model =
        InheritedModel.inheritFrom<EquipmentProfiles>(context, aspect: _EquipmentProfilesModelAspect.profiles)!;
    return List<IEquipmentProfile>.from(
      [
        EquipmentProfilesProvider.defaultProfile,
        ...model.profiles.values.map((p) => p.value),
      ],
    );
  }

  static List<IEquipmentProfile> inUseOf(BuildContext context) {
    final model =
        InheritedModel.inheritFrom<EquipmentProfiles>(context, aspect: _EquipmentProfilesModelAspect.profilesInUse)!;
    return List<IEquipmentProfile>.from(
      [
        EquipmentProfilesProvider.defaultProfile,
        ...model.profiles.values.where((p) => p.isUsed).map((p) => p.value),
      ],
    );
  }

  static IEquipmentProfile selectedOf(BuildContext context) {
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

extension on Object {
  T? changedOrNull<T>(T newValue) {
    return this != newValue ? newValue : null;
  }
}
