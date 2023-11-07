import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

class DialogSwitch<T> extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Map<T, bool> values;
  final String Function(BuildContext context, T value) titleAdapter;
  final ValueChanged<Map<T, bool>> onSave;

  const DialogSwitch({
    required this.icon,
    required this.title,
    required this.description,
    required this.values,
    required this.titleAdapter,
    required this.onSave,
    super.key,
  });

  @override
  State<DialogSwitch<T>> createState() => _DialogSwitchState<T>();
}

class _DialogSwitchState<T> extends State<DialogSwitch<T>> {
  late final Map<T, bool> _features = Map.from(widget.values);

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingL),
              child: Text(widget.description),
            ),
            const SizedBox(height: Dimens.grid16),
            ListView(
              shrinkWrap: true,
              children: _features.entries
                  .map(
                    (entry) => SwitchListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: Dimens.dialogTitlePadding.left),
                      title: Text(widget.titleAdapter(context, entry.key)),
                      value: _features[entry.key]!,
                      onChanged: (value) {
                        setState(() {
                          _features.update(entry.key, (_) => value);
                        });
                      },
                    ),
                  )
                  .toList(),
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
          onPressed: () {
            widget.onSave(_features);
            Navigator.of(context).pop();
          },
          child: Text(S.of(context).save),
        ),
      ],
    );
  }
}
