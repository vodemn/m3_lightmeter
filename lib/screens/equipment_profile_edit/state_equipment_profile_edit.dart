import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class EquipmentProfileEditState<T extends IEquipmentProfile> {
  final T profile;
  final T? profileToCopy;
  final bool canSave;
  final bool isLoading;

  const EquipmentProfileEditState({
    required this.profile,
    required this.canSave,
    this.isLoading = false,
    this.profileToCopy,
  });

  EquipmentProfileEditState<T> copyWith({
    T? profile,
    T? profileToCopy,
    bool? canSave,
    bool? isLoading,
  }) =>
      EquipmentProfileEditState<T>(
        profile: profile ?? this.profile,
        profileToCopy: profileToCopy ?? this.profileToCopy,
        canSave: canSave ?? this.canSave,
        isLoading: isLoading ?? this.isLoading,
      );
}
