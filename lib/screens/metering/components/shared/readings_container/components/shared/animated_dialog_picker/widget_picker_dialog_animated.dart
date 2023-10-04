import 'package:flutter/material.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/animated_dialog/widget_dialog_animated.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/dialog_picker/widget_picker_dialog.dart';

// Has to be stateful, so that [GlobalKey] is not recreated. 
// Otherwise use will no be able to close the dialog after EV value has changed.
class AnimatedDialogPicker<T> extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final T selectedValue;
  final List<T> values;
  final DialogPickerItemTitleBuilder<T> itemTitleBuilder;
  final DialogPickerItemTrailingBuilder<T>? itemTrailingBuilder;
  final ValueChanged<T> onChanged;
  final Widget closedChild;

  const AnimatedDialogPicker({
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
  State<AnimatedDialogPicker<T>> createState() => _AnimatedDialogPickerState<T>();
}

class _AnimatedDialogPickerState<T> extends State<AnimatedDialogPicker<T>> {
  final _key = GlobalKey<AnimatedDialogState>();

  @override
  Widget build(BuildContext context) {
    return AnimatedDialog(
      key: _key,
      closedChild: widget.closedChild,
      openedChild: DialogPicker<T>(
        icon: widget.icon,
        title: widget.title,
        subtitle: widget.subtitle,
        initialValue: widget.selectedValue,
        values: widget.values,
        itemTitleBuilder: widget.itemTitleBuilder,
        itemTrailingBuilder: widget.itemTrailingBuilder,
        onCancel: () {
          _key.currentState?.close();
        },
        onSelect: (value) {
          _key.currentState?.close().then((_) => widget.onChanged(value));
        },
      ),
    );
  }
}
