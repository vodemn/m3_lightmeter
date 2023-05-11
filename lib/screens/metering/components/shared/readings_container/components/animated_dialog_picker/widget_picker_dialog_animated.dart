import 'package:flutter/material.dart';

import 'package:lightmeter/screens/metering/components/shared/readings_container/components/animated_dialog_picker/components/animated_dialog/widget_dialog_animated.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/animated_dialog_picker/components/dialog_picker/widget_picker_dialog.dart';

class AnimatedDialogPicker<T> extends StatelessWidget {
  final _key = GlobalKey<AnimatedDialogState>();
  final IconData icon;
  final String title;
  final String? subtitle;
  final T selectedValue;
  final List<T> values;
  final DialogPickerItemTitleBuilder<T> itemTitleBuilder;
  final DialogPickerItemTrailingBuilder<T>? itemTrailingBuilder;
  final ValueChanged<T> onChanged;
  final Widget closedChild;

  AnimatedDialogPicker({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.selectedValue,
    required this.values,
    required this.itemTitleBuilder,
    this.itemTrailingBuilder,
    required this.onChanged,
    required this.closedChild,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedDialog(
      key: _key,
      closedChild: closedChild,
      openedChild: DialogPicker<T>(
        icon: icon,
        title: title,
        subtitle: subtitle,
        initialValue: selectedValue,
        values: values,
        itemTitleBuilder: itemTitleBuilder,
        itemTrailingBuilder: itemTrailingBuilder,
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
