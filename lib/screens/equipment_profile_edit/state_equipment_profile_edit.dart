import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class EquipmentProfileEditState<T extends IEquipmentProfile> {
  final T profile;
  final T? profileToCopy;
  final bool hasChanges;
  final bool isValid;
  final bool isLoading;

  const EquipmentProfileEditState({
    required this.profile,
    required this.hasChanges,
    required this.isValid,
    this.isLoading = false,
    this.profileToCopy,
  });

  EquipmentProfileEditState<T> copyWith({
    T? profile,
    T? profileToCopy,
    bool? isValid,
    bool? hasChanges,
    bool? isLoading,
  }) =>
      EquipmentProfileEditState<T>(
        profile: profile ?? this.profile,
        profileToCopy: profileToCopy ?? this.profileToCopy,
        isValid: isValid ?? this.isValid,
        hasChanges: hasChanges ?? this.hasChanges,
        isLoading: isLoading ?? this.isLoading,
      );
}
