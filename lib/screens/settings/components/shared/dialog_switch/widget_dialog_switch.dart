import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/utils/context_utils.dart';
import 'package:lightmeter/utils/guard_pro_tap.dart';

typedef StringAdapter<T> = String Function(BuildContext context, T value);

class DialogSwitchListItem<T> {
  final T value;
  final String title;
  final String? subtitle;
  final bool initialValue;
  final bool isEnabled;
  final bool isProRequired;

  const DialogSwitchListItem({
    required this.value,
    required this.title,
    this.subtitle,
    required this.initialValue,
    this.isEnabled = true,
    this.isProRequired = false,
  });
}

class DialogSwitch<T> extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? description;
  final List<DialogSwitchListItem<T>> items;
  final ValueChanged<Map<T, bool>> onSave;

  const DialogSwitch({
    required this.icon,
    required this.title,
    this.description,
    required this.items,
    required this.onSave,
    super.key,
  });

  @override
  State<DialogSwitch<T>> createState() => _DialogSwitchState<T>();
}

class _DialogSwitchState<T> extends State<DialogSwitch<T>> {
  late final Map<T, bool> _features = Map.fromEntries(
    widget.items.map(
      (item) => MapEntry(item.value, item.initialValue),
    ),
  );

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
              const SizedBox(height: Dimens.grid16),
            ],
            ListView(
              shrinkWrap: true,
              children: widget.items.map(
                (item) {
                  final value = _features[item.value]!;
                  return SwitchListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: Dimens.dialogTitlePadding.left),
                    title: Text(item.title),
                    subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
                    value: item.isProRequired ? context.isPro && value : value,
                    onChanged: item.isEnabled ? (value) => _setItem(item, value) : null,
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

  void _setItem(DialogSwitchListItem<T> item, bool value) {
    void setItemState() {
      setState(() {
        _features.update(item.value, (_) => value);
      });
    }

    if (item.isProRequired) {
      guardProTap(context, setItemState);
    } else {
      setItemState();
    }
  }
}
