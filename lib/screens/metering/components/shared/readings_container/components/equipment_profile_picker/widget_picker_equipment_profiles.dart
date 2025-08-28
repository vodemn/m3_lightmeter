import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/widget_picker_dialog_animated.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/reading_value_container/widget_container_reading_value.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class EquipmentProfilePicker extends StatelessWidget {
  const EquipmentProfilePicker();

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogPicker<EquipmentProfile>(
      icon: Icons.camera_alt_outlined,
      title: S.of(context).equipmentProfile,
      selectedValue: EquipmentProfiles.selectedOf(context),
      values: EquipmentProfiles.inUseOf(context),
      itemTitleBuilder: (_, value) => Text(value.id.isEmpty ? S.of(context).none : value.name),
      onChanged: EquipmentProfilesProvider.of(context).selectProfile,
      closedChild: ReadingValueContainer.singleValue(
        value: ReadingValue(
          label: S.of(context).equipmentProfile,
          value: EquipmentProfiles.selectedOf(context).id.isEmpty
              ? S.of(context).none
              : EquipmentProfiles.selectedOf(context).name,
        ),
      ),
    );
  }
}
