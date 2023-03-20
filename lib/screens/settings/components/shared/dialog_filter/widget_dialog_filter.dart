import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class DialogFilter<T extends PhotographyValue> extends StatefulWidget {
  final Icon icon;
  final String title;
  final String description;
  final List<T> values;
  final List<T> selectedValues;
  final String Function(BuildContext context, T value) titleAdapter;
  final bool rangeSelect;

  const DialogFilter({
    required this.icon,
    required this.title,
    required this.description,
    required this.values,
    required this.selectedValues,
    required this.titleAdapter,
    this.rangeSelect = false,
    super.key,
  });

  @override
  State<DialogFilter<T>> createState() => _DialogFilterState<T>();
}

class _DialogFilterState<T extends PhotographyValue> extends State<DialogFilter<T>> {
  late final List<bool> checkboxValues = List.generate(
    widget.values.length,
    (index) => widget.selectedValues.any((element) => element.value == widget.values[index].value),
    growable: false,
  );

  bool get _hasAnySelected => checkboxValues.contains(true);
  bool get _hasAnyUnselected => checkboxValues.contains(false);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: widget.icon,
      titlePadding: Dimens.dialogIconTitlePadding,
      title: Text(widget.title),
      contentPadding: EdgeInsets.zero,
      content: Column(
        children: [
          Padding(
            padding: Dimens.dialogIconTitlePadding,
            child: Text(widget.description),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  widget.values.length,
                  (index) => CheckboxListTile(
                    value: checkboxValues[index],
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      widget.titleAdapter(context, widget.values[index]),
                      style: Theme.of(context).textTheme.bodyLarge!,
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          if (widget.rangeSelect) {
                            if (value) {
                              final indexOfChecked = checkboxValues.indexOf(value);
                              if (indexOfChecked == -1) {
                                checkboxValues[index] = value;
                              } else if (indexOfChecked < index) {
                                checkboxValues.fillRange(indexOfChecked, index + 1, value);
                              } else {
                                checkboxValues.fillRange(index, indexOfChecked, value);
                              }
                            } else {
                              if (index > checkboxValues.length / 2) {
                                checkboxValues.fillRange(index, checkboxValues.length, false);
                                checkboxValues[index] = value;
                              } else {
                                checkboxValues.fillRange(0, index, false);
                                checkboxValues[index] = value;
                              }
                            }
                          } else {
                            checkboxValues[index] = value;
                          }
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: Dimens.dialogActionsPadding,
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(_hasAnyUnselected ? Icons.select_all : Icons.deselect),
                    onPressed: _toggleAll,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text(S.of(context).cancel),
                ),
                TextButton(
                  onPressed: _hasAnySelected
                      ? () {
                          List<T> selectedValues = [];
                          for (int i = 0; i < widget.values.length; i++) {
                            if (checkboxValues[i]) {
                              selectedValues.add(widget.values[i]);
                            }
                          }
                          Navigator.of(context).pop(selectedValues);
                        }
                      : null,
                  child: Text(S.of(context).save),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _toggleAll() {
    setState(() {
      if (_hasAnyUnselected) {
        checkboxValues.fillRange(0, checkboxValues.length, true);
      } else {
        checkboxValues.fillRange(0, checkboxValues.length, false);
      }
    });
  }
}
