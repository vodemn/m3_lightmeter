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
  final bool locked;
  final Color? color;
  final Color? textColor;

  ReadingValueContainer({
    required List<ReadingValue> values,
    this.locked = false,
    this.color,
    this.textColor,
    super.key,
  }) {
    _items = [];
    for (int i = 0; i < values.length; i++) {
      if (i > 0) {
        _items.add(const SizedBox(height: Dimens.grid8));
      }
      _items.add(_ReadingValueBuilder(values[i], textColor: textColor));
    }
  }

  ReadingValueContainer.singleValue({
    required ReadingValue value,
    this.locked = false,
    this.color,
    this.textColor,
    super.key,
  }) : _items = [_ReadingValueBuilder(value, textColor: textColor)];

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
          child: Stack(
            children: [
              if (locked)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.lock_outline,
                    size: Theme.of(context).textTheme.labelMedium!.fontSize,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: _items,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadingValueBuilder extends StatelessWidget {
  final ReadingValue reading;
  final Color? textColor;

  const _ReadingValueBuilder(this.reading, {this.textColor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = textColor ?? Theme.of(context).colorScheme.onPrimaryContainer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          reading.label,
          style: textTheme.labelMedium?.copyWith(color: color),
          maxLines: 1,
          overflow: TextOverflow.visible,
          softWrap: false,
        ),
        const SizedBox(height: Dimens.grid4),
        AnimatedSwitcher(
          duration: Dimens.switchDuration,
          child: Text(
            reading.value,
            style: textTheme.titleMedium?.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      ],
    );
  }
}
