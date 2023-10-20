import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/widget_picker_dialog_animated.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/reading_value_container/widget_container_reading_value.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class NdValuePicker extends StatelessWidget {
  final List<NdValue> values;
  final NdValue selectedValue;
  final ValueChanged<NdValue> onChanged;

  const NdValuePicker({
    required this.selectedValue,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogPicker<NdValue>(
      icon: Icons.filter_b_and_w,
      title: S.of(context).nd,
      subtitle: S.of(context).ndFilterFactor,
      selectedValue: selectedValue,
      values: values,
      itemTitleBuilder: (_, value) => Text(
        value.value == 0 ? S.of(context).none : value.value.toString(),
      ),
      // using descending order, because ND filter darkens image & lowers EV
      itemTrailingBuilder: (selected, value) =>
          value.value != selected.value ? Text(S.of(context).evValue(value.toStringDifference(selected))) : null,
      onChanged: onChanged,
      closedChild: ReadingValueContainer.singleValue(
        value: ReadingValue(
          label: S.of(context).nd,
          value: selectedValue.value == 0 ? S.of(context).none : selectedValue.value.toString(),
        ),
      ),
    );
  }
}
