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
  final TogglableMap<PinholeEquipmentProfile> _pinholeCustomProfiles = {};
  String _selectedId = '';

  IEquipmentProfile get _selectedProfile =>
      _customProfiles[_selectedId]?.value ??
      _pinholeCustomProfiles[_selectedId]?.value ??
      EquipmentProfilesProvider.defaultProfile;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return EquipmentProfiles(
      profiles: context.isPro ? _customProfiles : {},
      pinholeProfiles: context.isPro ? _pinholeCustomProfiles : {},
      selected: context.isPro ? _selectedProfile : EquipmentProfilesProvider.defaultProfile,
      child: widget.child,
    );
  }

  Future<void> _init() async {
    _selectedId = widget.storageService.selectedEquipmentProfileId;
    _customProfiles.addAll(await widget.storageService.getEquipmentProfiles());
    _pinholeCustomProfiles.addAll(await widget.storageService.getPinholeEquipmentProfiles());
    _discardSelectedIfNotIncluded();
    if (mounted) setState(() {});
    widget.onInitialized?.call();
  }

  Future<void> addProfile(IEquipmentProfile profile) async {
    switch (profile) {
      case final PinholeEquipmentProfile profile:
        await widget.storageService.addPinholeEquipmentProfile(profile);
        _pinholeCustomProfiles[profile.id] = (value: profile, isUsed: true);
      case final EquipmentProfile profile:
        await widget.storageService.addEquipmentProfile(profile);
        _customProfiles[profile.id] = (value: profile, isUsed: true);
    }
    setState(() {});
  }

  Future<void> updateProfile(IEquipmentProfile profile) async {
    switch (profile) {
      case final PinholeEquipmentProfile profile:
        final oldProfile = _pinholeCustomProfiles[profile.id]!.value;
        await widget.storageService.updatePinholeEquipmentProfile(
          id: profile.id,
          name: profile.name,
          aperture: oldProfile.aperture.changedOrNull(profile.aperture),
          isoValues: oldProfile.isoValues.changedOrNull(profile.isoValues),
          lensZoom: oldProfile.lensZoom.changedOrNull(profile.lensZoom),
          exposureOffset: oldProfile.exposureOffset.changedOrNull(profile.exposureOffset),
        );
        _pinholeCustomProfiles[profile.id] = (value: profile, isUsed: _pinholeCustomProfiles[profile.id]!.isUsed);
      case final EquipmentProfile profile:
        final oldProfile = _customProfiles[profile.id]!.value;
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
        _customProfiles[profile.id] = (value: profile, isUsed: _customProfiles[profile.id]!.isUsed);
    }
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
        _pinholeCustomProfiles.remove(profile.id);
      case final EquipmentProfile profile:
        await widget.storageService.deleteEquipmentProfile(profile.id);
        _customProfiles.remove(profile.id);
    }
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
    if (_customProfiles.containsKey(id)) {
      _customProfiles[id] = (value: _customProfiles[id]!.value, isUsed: enabled);
      await widget.storageService.updateEquipmentProfile(id: id, isUsed: enabled);
    } else if (_pinholeCustomProfiles.containsKey(id)) {
      _pinholeCustomProfiles[id] = (value: _pinholeCustomProfiles[id]!.value, isUsed: enabled);
      await widget.storageService.updatePinholeEquipmentProfile(id: id, isUsed: enabled);
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
    final isSelectedUsed = _customProfiles[_selectedId]?.isUsed ?? _pinholeCustomProfiles[_selectedId]?.isUsed ?? false;
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
  final TogglableMap<PinholeEquipmentProfile> pinholeProfiles;
  final IEquipmentProfile selected;

  const EquipmentProfiles({
    required this.profiles,
    required this.pinholeProfiles,
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
        ...model.pinholeProfiles.values.map((p) => p.value),
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
        ...model.pinholeProfiles.values.where((p) => p.isUsed).map((p) => p.value),
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
            (const DeepCollectionEquality().equals(oldWidget.profiles, profiles) ||
                const DeepCollectionEquality().equals(oldWidget.pinholeProfiles, pinholeProfiles)));
  }
}

extension on Object {
  T? changedOrNull<T>(T newValue) {
    return this != newValue ? newValue : null;
  }
}
