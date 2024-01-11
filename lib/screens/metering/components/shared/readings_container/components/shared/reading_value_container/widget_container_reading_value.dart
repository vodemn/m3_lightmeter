import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/animated_dialog_picker/components/animated_dialog/widget_dialog_animated.dart';

class ReadingValue {
  final String label;
  final String value;

  const ReadingValue({
    required this.label,
    required this.value,
  });
}

class ReadingValueContainer extends StatelessWidget implements AnimatedDialogClosedChild {
  late final List<Widget> _items;
  final Color? color;

  ReadingValueContainer({
    required List<ReadingValue> values,
    this.color,
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
    this.color,
    super.key,
  }) : _items = [_ReadingValueBuilder(value)];

  @override
  Color backgroundColor(BuildContext context) => color ?? Theme.of(context).colorScheme.primaryContainer;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.borderRadiusM),
      child: ColoredBox(
        color: backgroundColor(context),
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
        AnimatedSwitcher(
          duration: Dimens.switchDuration,
          child: Text(
            reading.value,
            style: textTheme.titleMedium?.copyWith(color: textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        )
      ],
    );
  }
}
