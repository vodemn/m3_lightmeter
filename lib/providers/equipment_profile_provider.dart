import 'package:flutter/material.dart';
import 'package:lightmeter/utils/context_utils.dart';
import 'package:lightmeter/utils/selectable_provider.dart';
import 'package:m3_lightmeter_iap/m3_lightmeter_iap.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:uuid/uuid.dart';

class EquipmentProfileProvider extends StatefulWidget {
  final IAPStorageService storageService;
  final Widget child;

  const EquipmentProfileProvider({
    required this.storageService,
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

  List<EquipmentProfile> _customProfiles = [];
  String _selectedId = '';

  EquipmentProfile get _selectedProfile => _customProfiles.firstWhere(
        (e) => e.id == _selectedId,
        orElse: () => _defaultProfile,
      );

  @override
  void initState() {
    super.initState();
    _selectedId = widget.storageService.selectedEquipmentProfileId;
    _customProfiles = widget.storageService.equipmentProfiles;
  }

  @override
  Widget build(BuildContext context) {
    return EquipmentProfiles(
      values: [
        _defaultProfile,
        if (context.isPro) ..._customProfiles,
      ],
      selected: context.isPro ? _selectedProfile : _defaultProfile,
      child: widget.child,
    );
  }

  void setProfile(EquipmentProfile data) {
    if (_selectedId != data.id) {
      setState(() {
        _selectedId = data.id;
      });
      widget.storageService.selectedEquipmentProfileId = _selectedProfile.id;
    }
  }

  /// Creates a default equipment profile
  void addProfile(String name, [EquipmentProfile? copyFrom]) {
    _customProfiles.add(
      EquipmentProfile(
        id: const Uuid().v1(),
        name: name,
        apertureValues: copyFrom?.apertureValues ?? ApertureValue.values,
        ndValues: copyFrom?.ndValues ?? NdValue.values,
        shutterSpeedValues: copyFrom?.shutterSpeedValues ?? ShutterSpeedValue.values,
        isoValues: copyFrom?.isoValues ?? IsoValue.values,
      ),
    );
    _refreshSavedProfiles();
  }

  void updateProfile(EquipmentProfile data) {
    final indexToUpdate = _customProfiles.indexWhere((element) => element.id == data.id);
    if (indexToUpdate >= 0) {
      _customProfiles[indexToUpdate] = data;
      _refreshSavedProfiles();
    }
  }

  void deleteProfile(EquipmentProfile data) {
    if (data.id == _selectedId) {
      _selectedId = _defaultProfile.id;
      widget.storageService.selectedEquipmentProfileId = _defaultProfile.id;
    }
    _customProfiles.remove(data);
    _refreshSavedProfiles();
  }

  void _refreshSavedProfiles() {
    widget.storageService.equipmentProfiles = _customProfiles;
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
