import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/topbar/models/reading_value.dart';

class ReadingContainer extends StatelessWidget {
  final List<_ReadingValueBuilder> _items;

  ReadingContainer({
    required List<ReadingValue> values,
    super.key,
  }) : _items = values.map((e) => _ReadingValueBuilder(e)).toList();

  ReadingContainer.singleValue({
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          reading.label,
          style: textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        const SizedBox(height: Dimens.grid4),
        Text(
          reading.value,
          style: textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
      ],
    );
  }
}
