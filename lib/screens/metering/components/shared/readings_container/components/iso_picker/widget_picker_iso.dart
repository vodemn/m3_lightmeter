import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/widget_picker_dialog_animated.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/reading_value_container/widget_container_reading_value.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class IsoValuePicker extends StatelessWidget {
  final List<IsoValue> values;
  final IsoValue selectedValue;
  final ValueChanged<IsoValue> onChanged;

  const IsoValuePicker({
    required this.selectedValue,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedDialogPicker<IsoValue>(
      icon: Icons.iso_outlined,
      title: S.of(context).iso,
      subtitle: S.of(context).filmSpeed,
      selectedValue: selectedValue,
      values: values,
      itemTitleBuilder: (_, value) => Text(value.value.toString()),
      // using ascending order, because increase in film speed rises EV
      itemTrailingBuilder: (selected, value) =>
          value.value != selected.value ? Text(S.of(context).evValue(selected.toStringDifference(value))) : null,
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
