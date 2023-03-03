import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

typedef DialogPickerItemBuilder<T extends PhotographyValue> = Widget Function(BuildContext, T);
typedef DialogPickerEvDifferenceBuilder<T extends PhotographyValue> = String Function(
    T selected, T other);

class PhotographyValuePickerDialog<T extends PhotographyValue> extends StatefulWidget {
  final String title;
  final String subtitle;
  final T initialValue;
  final List<T> values;
  final DialogPickerItemBuilder<T> itemTitleBuilder;
  final DialogPickerEvDifferenceBuilder<T> evDifferenceBuilder;
  final VoidCallback onCancel;
  final ValueChanged onSelect;

  const PhotographyValuePickerDialog({
    required this.title,
    required this.subtitle,
    required this.initialValue,
    required this.values,
    required this.itemTitleBuilder,
    required this.evDifferenceBuilder,
    required this.onCancel,
    required this.onSelect,
    super.key,
  });

  @override
  State<PhotographyValuePickerDialog<T>> createState() => _PhotographyValuePickerDialogState<T>();
}

class _PhotographyValuePickerDialogState<T extends PhotographyValue>
    extends State<PhotographyValuePickerDialog<T>> {
  late T _selectedValue = widget.initialValue;
  late final _scrollController =
      ScrollController(initialScrollOffset: Dimens.grid56 * widget.values.indexOf(_selectedValue));

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: Dimens.dialogTitlePadding,
          child: Column(
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineSmall!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimens.grid16),
              Text(
                widget.subtitle,
                style: Theme.of(context).textTheme.bodyMedium!,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            itemCount: widget.values.length,
            itemExtent: Dimens.grid56,
            itemBuilder: (context, index) => RadioListTile(
              value: widget.values[index],
              groupValue: _selectedValue,
              title: DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyLarge!,
                child: widget.itemTitleBuilder(context, widget.values[index]),
              ),
              secondary: widget.values[index].value != _selectedValue.value
                  ? Text(S.of(context).evValue(
                      widget.evDifferenceBuilder.call(_selectedValue, widget.values[index])))
                  : null,
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
        const Divider(),
        Padding(
          padding: Dimens.dialogActionsPadding,
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
