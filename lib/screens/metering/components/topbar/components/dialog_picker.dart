import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

class MeteringScreenDialogPicker<T> extends StatefulWidget {
  final String title;
  final T initialValue;
  final List<T> values;
  final Widget Function(BuildContext context, T value) itemTitleBuilder;
  final VoidCallback onCancel;
  final ValueChanged onSelect;

  const MeteringScreenDialogPicker({
    required this.title,
    required this.initialValue,
    required this.values,
    required this.itemTitleBuilder,
    required this.onCancel,
    required this.onSelect,
    super.key,
  });

  @override
  State<MeteringScreenDialogPicker<T>> createState() => _MeteringScreenDialogPickerState<T>();
}

class _MeteringScreenDialogPickerState<T> extends State<MeteringScreenDialogPicker<T>> {
  late T _selectedValue = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            Dimens.paddingL,
            Dimens.paddingL,
            Dimens.paddingL,
            Dimens.paddingM,
          ),
          child: Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineSmall!,
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          height: 0,
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: widget.values.length,
            itemBuilder: (context, index) => RadioListTile(
              value: widget.values[index],
              groupValue: _selectedValue,
              title: DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyLarge!,
                child: widget.itemTitleBuilder(context, widget.values[index]),
              ),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedValue = value;
                  });
                }
              },
            ),
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          height: 0,
        ),
        Padding(
          padding: const EdgeInsets.all(Dimens.paddingL),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              TextButton(
                onPressed: widget.onCancel,
                child: Text(S.of(context).cancel),
              ),
              const SizedBox(width: Dimens.grid16),
              TextButton(
                onPressed: () => widget.onSelect(_selectedValue),
                child: Text(S.of(context).select),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
