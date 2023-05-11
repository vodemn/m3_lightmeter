import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class DialogRangePicker<T extends PhotographyValue> extends StatefulWidget {
  final Icon icon;
  final String title;
  final String description;
  final List<T> values;
  final List<T> selectedValues;
  final String Function(BuildContext context, T value) titleAdapter;

  const DialogRangePicker({
    required this.icon,
    required this.title,
    required this.description,
    required this.values,
    required this.selectedValues,
    required this.titleAdapter,
    super.key,
  });

  @override
  State<DialogRangePicker<T>> createState() => _DialogRangePickerState<T>();
}

class _DialogRangePickerState<T extends PhotographyValue> extends State<DialogRangePicker<T>> {
  late int _start = widget.values.indexWhere((e) => e.value == widget.selectedValues.first.value);
  late int _end = widget.values.indexWhere((e) => e.value == widget.selectedValues.last.value);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: widget.icon,
      titlePadding: Dimens.dialogIconTitlePadding,
      title: Text(widget.title),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: Dimens.dialogIconTitlePadding,
            child: Text(widget.description),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingL),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyLarge!,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.values[_start].toString()),
                  Text(widget.values[_end].toString()),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: RangeSlider(
                  values: RangeValues(
                    _start.toDouble(),
                    _end.toDouble(),
                  ),
                  max: widget.values.length.toDouble() - 1,
                  divisions: widget.values.length - 1,
                  onChanged: (value) {
                    setState(() {
                      _start = value.start.toInt();
                      _end = value.end.toInt();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      actionsPadding: Dimens.dialogActionsPadding,
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(S.of(context).cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(widget.values.sublist(_start, _end + 1)),
          child: Text(S.of(context).save),
        ),
      ],
    );
  }
}
