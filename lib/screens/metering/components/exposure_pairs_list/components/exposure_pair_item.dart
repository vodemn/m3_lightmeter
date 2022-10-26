import 'package:flutter/material.dart';
import 'package:lightmeter/models/photography_value.dart';
import 'package:lightmeter/res/dimens.dart';

class ExposurePaitListItem<T extends PhotographyValue> extends StatelessWidget {
  final T value;
  final bool tickOnTheLeft;

  const ExposurePaitListItem(this.value, {required this.tickOnTheLeft, super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowChildren = [
      Text(
        value.toString(),
        style: labelTextStyle(context).copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
      const SizedBox(width: Dimens.grid8),
      ColoredBox(
        color: Theme.of(context).colorScheme.onBackground,
        child: SizedBox(
          height: 1,
          width: tickLength(),
        ),
      ),
    ];
    return Row(
      mainAxisAlignment: tickOnTheLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: tickOnTheLeft ? rowChildren.reversed.toList() : rowChildren,
    );
  }

  TextStyle labelTextStyle(BuildContext context) {
    switch (value.stopType) {
      case Stop.full:
        return Theme.of(context).textTheme.bodyLarge!;
      case Stop.half:
        return Theme.of(context).textTheme.bodyMedium!;
      case Stop.third:
        return Theme.of(context).textTheme.bodySmall!;
    }
  }

  double tickLength() {
    switch (value.stopType) {
      case Stop.full:
        return Dimens.grid24;
      case Stop.half:
        return Dimens.grid16;
      case Stop.third:
        return Dimens.grid8;
    }
  }
}
