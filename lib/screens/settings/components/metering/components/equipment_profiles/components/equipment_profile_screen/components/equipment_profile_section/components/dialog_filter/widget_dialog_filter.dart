import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class DialogFilter<T extends PhotographyValue> extends StatefulWidget {
  final Icon icon;
  final String title;
  final String description;
  final List<T> values;
  final String Function(BuildContext context, T value) titleAdapter;
  final bool rangeSelect;

  const DialogFilter({
    required this.icon,
    required this.title,
    required this.description,
    required this.values,
    required this.titleAdapter,
    this.rangeSelect = false,
    super.key,
  });

  @override
  State<DialogFilter<T>> createState() => _DialogFilterState<T>();
}

class _DialogFilterState<T extends PhotographyValue> extends State<DialogFilter<T>> {
  late final List<bool> _selectedValues = List.generate(
    widget.values.length,
    (_) => true,
    growable: false,
  );

  bool get _hasAnySelected => _selectedValues.contains(true);
  bool get _hasAnyUnselected => _selectedValues.contains(false);

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
          // TODO: try to find lazy-building solution
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  widget.values.length,
                  (index) => CheckboxListTile(
                    value: _selectedValues[index],
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
                              final indexOfChecked = _selectedValues.indexOf(value);
                              if (indexOfChecked == -1) {
                                _selectedValues[index] = value;
                              } else if (indexOfChecked < index) {
                                _selectedValues.fillRange(indexOfChecked, index + 1, value);
                              } else {
                                _selectedValues.fillRange(index, indexOfChecked, value);
                              }
                            } else {
                              if (index > _selectedValues.length / 2) {
                                _selectedValues.fillRange(index, _selectedValues.length, false);
                                _selectedValues[index] = value;
                              } else {
                                _selectedValues.fillRange(0, index, false);
                                _selectedValues[index] = value;
                              }
                            }
                          } else {
                            _selectedValues[index] = value;
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
                  onPressed:
                      _hasAnySelected ? () => Navigator.of(context).pop(_selectedValues) : null,
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
        _selectedValues.fillRange(0, _selectedValues.length, true);
      } else {
        _selectedValues.fillRange(0, _selectedValues.length, false);
      }
    });
  }
}
