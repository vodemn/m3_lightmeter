import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/models/photography_value.dart';
import 'package:lightmeter/res/dimens.dart';

typedef DialogPickerItemBuilder<T extends PhotographyValue> = Widget Function(BuildContext, T);
typedef DialogPickerEvDifferenceBuilder<T extends PhotographyValue> = String Function(T selected, T other);

class MeteringScreenDialogPicker<T extends PhotographyValue> extends StatefulWidget {
  final String title;
  final String subtitle;
  final T initialValue;
  final List<T> values;
  final DialogPickerItemBuilder<T> itemTitleBuilder;
  final DialogPickerEvDifferenceBuilder<T> evDifferenceBuilder;
  final VoidCallback onCancel;
  final ValueChanged onSelect;

  const MeteringScreenDialogPicker({
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
  State<MeteringScreenDialogPicker<T>> createState() => _MeteringScreenDialogPickerState<T>();
}

class _MeteringScreenDialogPickerState<T extends PhotographyValue> extends State<MeteringScreenDialogPicker<T>> {
  late T _selectedValue = widget.initialValue;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(Dimens.grid56 * widget.values.indexOf(_selectedValue));
    });
  }

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
        ColoredBox(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Dimens.paddingL,
                  Dimens.paddingL,
                  Dimens.paddingL,
                  Dimens.paddingM,
                ),
                child: Column(
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.headlineSmall!,
                    ),
                    const SizedBox(height: Dimens.grid16),
                    Text(
                      widget.subtitle,
                      style: Theme.of(context).textTheme.bodyMedium!,
                    ),
                  ],
                ),
              ),
              Divider(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                height: 0,
              ),
            ],
          ),
        ),
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
                  ? Text('${widget.evDifferenceBuilder.call(_selectedValue, widget.values[index])} EV')
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
        ColoredBox(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            children: [
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
          ),
        ),
      ],
    );
  }
}
