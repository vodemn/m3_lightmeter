import 'package:flutter/material.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

import 'components/animated_dialog/widget_dialog_animated.dart';
import 'components/photography_value_picker_dialog/widget_dialog_picker_photography_value.dart';

class AnimatedDialogPicker<T extends PhotographyValue> extends StatelessWidget {
  final _key = GlobalKey<AnimatedDialogState>();
  final String title;
  final String subtitle;
  final T selectedValue;
  final List<T> values;
  final DialogPickerItemBuilder<T> itemTitleBuilder;
  final DialogPickerEvDifferenceBuilder<T> evDifferenceBuilder;
  final ValueChanged<T> onChanged;
  final Widget closedChild;

  AnimatedDialogPicker({
    required this.title,
    required this.subtitle,
    required this.selectedValue,
    required this.values,
    required this.itemTitleBuilder,
    required this.evDifferenceBuilder,
    required this.onChanged,
    required this.closedChild,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedDialog(
      key: _key,
      closedChild: closedChild,
      openedChild: PhotographyValuePickerDialog<T>(
        title: title,
        subtitle: subtitle,
        initialValue: selectedValue,
        values: values,
        itemTitleBuilder: itemTitleBuilder,
        evDifferenceBuilder: evDifferenceBuilder,
        onCancel: () {
          _key.currentState?.close();
        },
        onSelect: (value) {
          _key.currentState?.close().then((_) => onChanged(value));
        },
      ),
    );
  }
}
