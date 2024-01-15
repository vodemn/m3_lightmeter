import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/settings/components/shared/disable/widget_disable.dart';

typedef StringAdapter<T> = String Function(BuildContext context, T value);

class DialogSwitch<T> extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? description;
  final Map<T, bool> values;
  final StringAdapter<T> titleAdapter;
  final StringAdapter<T>? subtitleAdapter;
  final bool Function(T value)? enabledAdapter;
  final ValueChanged<Map<T, bool>> onSave;

  const DialogSwitch({
    required this.icon,
    required this.title,
    this.description,
    required this.values,
    required this.titleAdapter,
    this.subtitleAdapter,
    this.enabledAdapter,
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
            if (widget.description != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingL),
                child: Text(widget.description!),
              ),
              const SizedBox(height: Dimens.grid16)
            ],
            ListView(
              shrinkWrap: true,
              children: _features.entries.map(
                (entry) {
                  final isEnabled = widget.enabledAdapter?.call(entry.key) ?? true;
                  return Disable(
                    disable: !isEnabled,
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: Dimens.dialogTitlePadding.left),
                      title: Text(widget.titleAdapter(context, entry.key)),
                      subtitle: widget.subtitleAdapter != null
                          ? Text(
                              widget.subtitleAdapter!.call(context, entry.key),
                              style: Theme.of(context).listTileTheme.subtitleTextStyle,
                            )
                          : null,
                      value: isEnabled && _features[entry.key]!,
                      onChanged: (value) {
                        setState(() {
                          _features.update(entry.key, (_) => value);
                        });
                      },
                    ),
                  );
                },
              ).toList(),
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
