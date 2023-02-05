import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

class DialogPicker<T> extends StatefulWidget {
  final String title;
  final T selectedValue;
  final List<T> values;
  final String Function(BuildContext context, T value) titleAdapter;

  const DialogPicker({
    required this.title,
    required this.selectedValue,
    required this.values,
    required this.titleAdapter,
    super.key,
  });

  @override
  State<DialogPicker<T>> createState() => _DialogPickerState<T>();
}

class _DialogPickerState<T> extends State<DialogPicker<T>> {
  late T _selected = widget.selectedValue;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: Dimens.dialogTitlePadding,
      title: Text(widget.title),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.values
            .map(
              (e) => RadioListTile(
                value: e,
                groupValue: _selected,
                title: Text(widget.titleAdapter(context, e)),
                onChanged: (T? value) {
                  if (value != null) {
                    setState(() {
                      _selected = value;
                    });
                  }
                },
              ),
            )
            .toList(),
      ),
      actionsPadding: Dimens.dialogActionsPadding,
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(S.of(context).cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_selected),
          child: Text(S.of(context).select),
        ),
      ],
    );
  }
}
