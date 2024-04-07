import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

class DialogSliderPicker extends StatefulWidget {
  final Icon icon;
  final String title;
  final String description;
  final double value;
  final RangeValues range;
  final String Function(BuildContext context, double value) valueAdapter;

  const DialogSliderPicker({
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.range,
    required this.valueAdapter,
    super.key,
  });

  @override
  State<DialogSliderPicker> createState() => _DialogSliderPickerState();
}

class _DialogSliderPickerState extends State<DialogSliderPicker> {
  late double value = widget.value;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: widget.icon,
      titlePadding: Dimens.dialogIconTitlePadding,
      title: Text(widget.title),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: Dimens.dialogIconTitlePadding,
              child: Text(widget.description),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingL),
              child: Text(
                widget.valueAdapter(context, value),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: value,
                    min: widget.range.start,
                    max: widget.range.end,
                    onChanged: (value) {
                      setState(() {
                        this.value = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actionsPadding: Dimens.dialogActionsPadding,
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: Text(S.of(context).cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(value),
          child: Text(S.of(context).save),
        ),
      ],
    );
  }
}
