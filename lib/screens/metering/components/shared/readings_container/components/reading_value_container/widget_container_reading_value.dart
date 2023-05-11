import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

class ReadingValue {
  final String label;
  final String value;

  const ReadingValue({
    required this.label,
    required this.value,
  });
}

class ReadingValueContainer extends StatelessWidget {
  late final List<Widget> _items;

  ReadingValueContainer({
    required List<ReadingValue> values,
    super.key,
  }) {
    _items = [];
    for (int i = 0; i < values.length; i++) {
      if (i > 0) {
        _items.add(const SizedBox(height: Dimens.grid8));
      }
      _items.add(_ReadingValueBuilder(values[i]));
    }
  }

  ReadingValueContainer.singleValue({
    required ReadingValue value,
    super.key,
  }) : _items = [_ReadingValueBuilder(value)];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.borderRadiusM),
      child: ColoredBox(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: _items,
          ),
        ),
      ),
    );
  }
}

class _ReadingValueBuilder extends StatelessWidget {
  final ReadingValue reading;

  const _ReadingValueBuilder(this.reading);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textColor = Theme.of(context).colorScheme.onPrimaryContainer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          reading.label,
          style: textTheme.labelMedium?.copyWith(color: textColor),
          maxLines: 1,
          overflow: TextOverflow.visible,
          softWrap: false,
        ),
        const SizedBox(height: Dimens.grid4),
        Text(
          reading.value,
          style: textTheme.titleMedium?.copyWith(color: textColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        )
      ],
    );
  }
}
