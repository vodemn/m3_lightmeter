import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

class DialogPicker<T> extends StatefulWidget {
  final IconData icon;
  final String title;
  final T selectedValue;
  final List<T> values;
  final String Function(BuildContext context, T value) titleAdapter;

  const DialogPicker({
    required this.icon,
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final selectedIndex = widget.values.indexOf(_selected);
      if (selectedIndex >= 0) {
        _scrollController.jumpTo((Dimens.grid56 * selectedIndex).clamp(0, _scrollController.position.maxScrollExtent));
      }
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
      icon: Icon(widget.icon),
      titlePadding: Dimens.dialogIconTitlePadding,
      title: Text(widget.title),
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            Flexible(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
              ),
            ),
            const Divider(),
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
          onPressed: () => Navigator.of(context).pop(_selected),
          child: Text(S.of(context).select),
        ),
      ],
    );
  }
}
