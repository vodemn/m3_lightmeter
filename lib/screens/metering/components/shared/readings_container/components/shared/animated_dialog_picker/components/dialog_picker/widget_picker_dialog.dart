import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/shared/transparent_dialog/widget_dialog_transparent.dart';

typedef DialogPickerItemTitleBuilder<T> = Widget Function(BuildContext context, T value);
typedef DialogPickerItemTrailingBuilder<T> = Widget? Function(T selected, T value);

class DialogPicker<T> extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final T initialValue;
  final List<T> values;
  final DialogPickerItemTitleBuilder<T> itemTitleBuilder;
  final DialogPickerItemTrailingBuilder<T>? itemTrailingBuilder;
  final VoidCallback onCancel;
  final ValueChanged<T> onSelect;

  const DialogPicker({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.initialValue,
    required this.values,
    required this.itemTitleBuilder,
    this.itemTrailingBuilder,
    required this.onCancel,
    required this.onSelect,
    super.key,
  });

  double height(BuildContext context) => TransparentDialog.height(
        context,
        title: title,
        subtitle: subtitle,
        scrollableContent: true,
        contextHeight: Dimens.grid56 * values.length,
      );

  @override
  State<DialogPicker<T>> createState() => _DialogPickerState<T>();
}

class _DialogPickerState<T> extends State<DialogPicker<T>> {
  late T _selectedValue = widget.initialValue;
  late final _scrollController =
      ScrollController(initialScrollOffset: Dimens.grid56 * widget.values.indexOf(_selectedValue));

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TransparentDialog(
      icon: widget.icon,
      title: widget.title,
      subtitle: widget.subtitle,
      content: Expanded(
        child: ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.zero,
          itemCount: widget.values.length,
          itemExtent: Dimens.grid56,
          itemBuilder: (context, index) => RadioListTile(
            value: widget.values[index],
            groupValue: _selectedValue,
            title: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyLarge!,
              child: widget.itemTitleBuilder(context, widget.values[index]),
            ),
            secondary: widget.itemTrailingBuilder?.call(_selectedValue, widget.values[index]),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedValue = value;
                });
              }
            },
          ),
        ),
      ),
      scrollableContent: true,
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text(S.of(context).cancel),
        ),
        TextButton(
          onPressed: () => widget.onSelect(_selectedValue),
          child: Text(S.of(context).select),
        ),
      ],
    );
  }
}
