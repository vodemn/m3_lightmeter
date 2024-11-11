import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class EquipmentProfileEditState {
  final String name;
  final List<ApertureValue> apertureValues;
  final List<NdValue> ndValues;
  final List<ShutterSpeedValue> shutterSpeedValues;
  final List<IsoValue> isoValues;
  final double lensZoom;
  final bool canSave;
  final bool isLoading;
  final EquipmentProfile? profileToCopy;

  const EquipmentProfileEditState({
    required this.name,
    required this.apertureValues,
    required this.ndValues,
    required this.shutterSpeedValues,
    required this.isoValues,
    required this.lensZoom,
    required this.canSave,
    this.isLoading = false,
    this.profileToCopy,
  });

  EquipmentProfileEditState copyWith({
    String? name,
    List<ApertureValue>? apertureValues,
    List<NdValue>? ndValues,
    List<ShutterSpeedValue>? shutterSpeedValues,
    List<IsoValue>? isoValues,
    double? lensZoom,
    bool? canSave,
    bool? isLoading,
    EquipmentProfile? profileToCopy,
  }) =>
      EquipmentProfileEditState(
        name: name ?? this.name,
        apertureValues: apertureValues ?? this.apertureValues,
        ndValues: ndValues ?? this.ndValues,
        shutterSpeedValues: shutterSpeedValues ?? this.shutterSpeedValues,
        isoValues: isoValues ?? this.isoValues,
        lensZoom: lensZoom ?? this.lensZoom,
        canSave: canSave ?? this.canSave,
        isLoading: isLoading ?? this.isLoading,
        profileToCopy: profileToCopy ?? this.profileToCopy,
      );
}
