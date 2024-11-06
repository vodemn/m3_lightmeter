import 'package:flutter/material.dart';
import 'package:lightmeter/utils/context_utils.dart';
import 'package:lightmeter/utils/selectable_provider.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class EquipmentProfileProvider extends StatefulWidget {
  final EquipmentProfilesStorageService storageService;
  final VoidCallback? onInitialized;
  final Widget child;

  const EquipmentProfileProvider({
    required this.storageService,
    this.onInitialized,
    required this.child,
    super.key,
  });

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

  final Map<String, EquipmentProfile> _customProfiles = {};
  String _selectedId = '';

  EquipmentProfile get _selectedProfile => _customProfiles[_selectedId] ?? _defaultProfile;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return EquipmentProfiles(
      values: [
        _defaultProfile,
        if (context.isPro) ..._customProfiles.values,
      ],
      selected: context.isPro ? _selectedProfile : _defaultProfile,
      child: widget.child,
    );
  }

  Future<void> _init() async {
    _selectedId = widget.storageService.selectedEquipmentProfileId;
    _customProfiles.addAll(await widget.storageService.getProfiles());
    if (mounted) setState(() {});
    widget.onInitialized?.call();
  }

  void setProfile(EquipmentProfile data) {
    if (_selectedId != data.id) {
      setState(() {
        _selectedId = data.id;
      });
      widget.storageService.selectedEquipmentProfileId = _selectedProfile.id;
    }
  }

  Future<void> addProfile(EquipmentProfile profile) async {
    await widget.storageService.addProfile(profile);
    _customProfiles[profile.id] = profile;
    setState(() {});
  }

  Future<void> updateProfile(EquipmentProfile profile) async {
    final oldProfile = _customProfiles[profile.id]!;
    await widget.storageService.updateProfile(
      id: profile.id,
      name: oldProfile.name != profile.name ? profile.name : null,
      apertureValues: oldProfile.apertureValues != profile.apertureValues ? profile.apertureValues : null,
      shutterSpeedValues:
          oldProfile.shutterSpeedValues != profile.shutterSpeedValues ? profile.shutterSpeedValues : null,
      isoValues: oldProfile.isoValues != profile.isoValues ? profile.isoValues : null,
      ndValues: oldProfile.ndValues != profile.ndValues ? profile.ndValues : null,
      lensZoom: oldProfile.lensZoom != profile.lensZoom ? profile.lensZoom : null,
    );
    _customProfiles[profile.id] = profile;
    setState(() {});
  }

  Future<void> deleteProfile(EquipmentProfile profile) async {
    await widget.storageService.deleteProfile(profile.id);
    if (profile.id == _selectedId) {
      _selectedId = _defaultProfile.id;
      widget.storageService.selectedEquipmentProfileId = _defaultProfile.id;
    }
    _customProfiles.remove(profile.id);
    setState(() {});
  }
}

class EquipmentProfiles extends SelectableInheritedModel<EquipmentProfile> {
  const EquipmentProfiles({
    super.key,
    required super.values,
    required super.selected,
    required super.child,
  });

  /// [_defaultProfile] + profiles created by the user
  static List<EquipmentProfile> of(BuildContext context) {
    return InheritedModel.inheritFrom<EquipmentProfiles>(context, aspect: SelectableAspect.list)!.values;
  }

  static EquipmentProfile selectedOf(BuildContext context) {
    return InheritedModel.inheritFrom<EquipmentProfiles>(
      context,
      aspect: SelectableAspect.selected,
    )!
        .selected;
  }
}
