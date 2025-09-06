import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/settings/components/shared/dialog_picker/widget_dialog_picker.dart';

enum EquipmentProfileType { regular, pinhole }

class EquipmentProfilesTypePicker extends StatelessWidget {
  const EquipmentProfilesTypePicker._();

  static Future<EquipmentProfileType?> show(BuildContext context) {
    return showDialog<EquipmentProfileType>(
      context: context,
      builder: (_) => const EquipmentProfilesTypePicker._(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogPicker<EquipmentProfileType>(
      icon: Icons.camera_alt_outlined,
      title: S.of(context).equipmentProfileType,
      selectedValue: EquipmentProfileType.regular,
      values: EquipmentProfileType.values,
      titleAdapter: (context, value) => switch (value) {
        EquipmentProfileType.regular => S.of(context).camera,
        EquipmentProfileType.pinhole => S.of(context).pinholeCamera,
      },
    );
  }
}
