import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';

typedef DialogPickerItemTitleBuilder<T> = Widget Function(BuildContext context, T value);
typedef DialogPickerItemTrailingBuilder<T> = Widget? Function(T selected, T value);

class DialogPicker<T> extends StatefulWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final T initialValue;
  final List<T> values;
  final DialogPickerItemTitleBuilder<T> itemTitleBuilder;
  final DialogPickerItemTrailingBuilder<T>? itemTrailingBuilder;
  final VoidCallback onCancel;
  final ValueChanged<T> onSelect;

  const DialogPicker({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.initialValue,
    required this.values,
    required this.itemTitleBuilder,
    this.itemTrailingBuilder,
    required this.onCancel,
    required this.onSelect,
    super.key,
  });

  double height(BuildContext context) {
    double textHeight(BuildContext context, String text, TextStyle? style) {
      final TextPainter titlePainter = TextPainter(
        text: TextSpan(
          text: text,
          style: style,
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: MediaQuery.of(context).size.width - Dimens.dialogIconTitlePadding.horizontal);
      return titlePainter.size.height + Dimens.dialogIconTitlePadding.vertical;
    }

    final titleHeight = textHeight(context, title, Theme.of(context).textTheme.headlineSmall);
    final subtitleHeight =
        subtitle != null ? textHeight(context, subtitle!, Theme.of(context).textTheme.bodyMedium) : 0;

    return (IconTheme.of(context).size! + Dimens.dialogTitlePadding.vertical) + // icon + icon padding
        titleHeight + // title + title padding
        subtitleHeight + // subtitle + subtitle padding
        Dimens.grid56 * values.length + // values summary height
        1 + // dividers
        (48 + Dimens.dialogActionsPadding.vertical); // actions + actions padding
  }

  @override
  State<DialogPicker<T>> createState() => _DialogPickerState<T>();
}

class _DialogPickerState<T> extends State<DialogPicker<T>> {
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: Dimens.dialogTitlePadding,
              child: Icon(widget.icon),
            ),
            Padding(
              padding: Dimens.dialogIconTitlePadding,
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            if (widget.subtitle != null)
              Padding(
                padding: Dimens.dialogIconTitlePadding,
                child: Text(
                  widget.subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
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
              secondary: widget.itemTrailingBuilder?.call(_selectedValue, widget.values[index]),
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
