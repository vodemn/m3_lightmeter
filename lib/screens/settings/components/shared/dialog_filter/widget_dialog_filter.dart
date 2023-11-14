import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

class DialogFilter<T> extends StatefulWidget {
  final Icon icon;
  final String title;
  final String description;
  final List<T> values;
  final List<T> selectedValues;
  final String Function(BuildContext context, T value) titleAdapter;

  const DialogFilter({
    required this.icon,
    required this.title,
    required this.description,
    required this.values,
    required this.selectedValues,
    required this.titleAdapter,
    super.key,
  });

  @override
  State<DialogFilter<T>> createState() => _DialogFilterState<T>();
}

class _DialogFilterState<T> extends State<DialogFilter<T>> {
  late final List<bool> checkboxValues = List.generate(
    widget.values.length,
    (index) => widget.selectedValues.any((element) => element == widget.values[index]),
    growable: false,
  );

  bool get _hasAnySelected => checkboxValues.contains(true);
  bool get _hasAnyUnselected => checkboxValues.contains(false);

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      int i = 0;
      for (; i < checkboxValues.length; i++) {
        if (checkboxValues[i]) {
          break;
        }
      }
      _scrollController.jumpTo((Dimens.grid56 * i).clamp(0, _scrollController.position.maxScrollExtent));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
          children: [
            Padding(
              padding: Dimens.dialogIconTitlePadding,
              child: Text(widget.description),
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
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
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            checkboxValues[index] = value;
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
                      tooltip: _hasAnyUnselected ? S.of(context).tooltipSelectAll : S.of(context).tooltipDesecelectAll,
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
                            final List<T> selectedValues = [];
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
