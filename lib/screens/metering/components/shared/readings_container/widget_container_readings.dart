import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

import 'components/animated_dialog_picker/widget_picker_dialog_animated.dart';
import 'components/reading_value_container/widget_container_reading_value.dart';

/// Contains a column of fastest & slowest exposure pairs + a row of ISO and ND pickers
class ReadingsContainer extends StatelessWidget {
  final ValueChanged<EquipmentProfileData> onEquipmentProfileChanged;
  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final List<IsoValue> isoValues;
  final IsoValue iso;
  final List<NdValue> ndValues;
  final NdValue nd;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;

  const ReadingsContainer({
    required this.onEquipmentProfileChanged,
    required this.fastest,
    required this.slowest,
    required this.isoValues,
    required this.iso,
    required this.ndValues,
    required this.nd,
    required this.onIsoChanged,
    required this.onNdChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (EquipmentProfile.of(context) != null &&
            (EquipmentProfiles.of(context)?.isNotEmpty ?? false)) ...[
          _EquipmentProfilePicker(
            selectedValue: EquipmentProfile.of(context)!,
            values: EquipmentProfiles.of(context)!,
            onChanged: (value) {
              EquipmentProfileProvider.of(context).setProfile(value);
              onEquipmentProfileChanged(value);
            },
          ),
          const _InnerPadding(),
        ],
        ReadingValueContainer(
          values: [
            ReadingValue(
              label: S.of(context).fastestExposurePair,
              value: fastest != null ? fastest!.toString() : '-',
            ),
            ReadingValue(
              label: S.of(context).slowestExposurePair,
              value: fastest != null ? slowest!.toString() : '-',
            ),
          ],
        ),
        const _InnerPadding(),
        Row(
          children: [
            Expanded(
              child: _IsoValuePicker(
                selectedValue: iso,
                values: isoValues,
                onChanged: onIsoChanged,
              ),
            ),
            const _InnerPadding(),
            Expanded(
              child: _NdValuePicker(
                selectedValue: nd,
                values: ndValues,
                onChanged: onNdChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InnerPadding extends SizedBox {
  const _InnerPadding() : super(height: Dimens.grid8, width: Dimens.grid8);
}

class _EquipmentProfilePicker extends StatelessWidget {
  final List<EquipmentProfileData> values;
  final EquipmentProfileData selectedValue;
  final ValueChanged<EquipmentProfileData> onChanged;

  const _EquipmentProfilePicker({
    required this.selectedValue,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogPicker<EquipmentProfileData>(
      title: S.of(context).equipmentProfiles,
      selectedValue: selectedValue,
      values: values,
      itemTitleBuilder: (_, value) => Text(value.id.isEmpty ? S.of(context).none : value.name),
      onChanged: onChanged,
      closedChild: ReadingValueContainer.singleValue(
        value: ReadingValue(
          label: S.of(context).equipmentProfiles,
          value: selectedValue.id.isEmpty ? S.of(context).none : selectedValue.name,
        ),
      ),
    );
  }
}

class _IsoValuePicker extends StatelessWidget {
  final List<IsoValue> values;
  final IsoValue selectedValue;
  final ValueChanged<IsoValue> onChanged;

  const _IsoValuePicker({
    required this.selectedValue,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogPicker<IsoValue>(
      title: S.of(context).iso,
      subtitle: S.of(context).filmSpeed,
      selectedValue: selectedValue,
      values: values,
      itemTitleBuilder: (_, value) => Text(value.value.toString()),
      // using ascending order, because increase in film speed rises EV
      itemTrailingBuilder: (selected, value) => value.value != selected.value
          ? Text(S.of(context).evValue(selected.toStringDifference(value)))
          : null,
      onChanged: onChanged,
      closedChild: ReadingValueContainer.singleValue(
        value: ReadingValue(
          label: S.of(context).iso,
          value: selectedValue.value.toString(),
        ),
      ),
    );
  }
}

class _NdValuePicker extends StatelessWidget {
  final List<NdValue> values;
  final NdValue selectedValue;
  final ValueChanged<NdValue> onChanged;

  const _NdValuePicker({
    required this.selectedValue,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogPicker<NdValue>(
      title: S.of(context).nd,
      subtitle: S.of(context).ndFilterFactor,
      selectedValue: selectedValue,
      values: values,
      itemTitleBuilder: (_, value) => Text(
        value.value == 0 ? S.of(context).none : value.value.toString(),
      ),
      // using descending order, because ND filter darkens image & lowers EV
      itemTrailingBuilder: (selected, value) => value.value != selected.value
          ? Text(S.of(context).evValue(value.toStringDifference(selected)))
          : null,
      onChanged: onChanged,
      closedChild: ReadingValueContainer.singleValue(
        value: ReadingValue(
          label: S.of(context).nd,
          value: selectedValue.value.toString(),
        ),
      ),
    );
  }
}
