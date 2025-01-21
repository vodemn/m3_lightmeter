import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class ExposurePairsListItem<T extends PhotographyStopValue> extends StatelessWidget {
  final T value;
  final bool tickOnTheLeft;

  const ExposurePairsListItem(
    this.value, {
    required this.tickOnTheLeft,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowChildren = [
      _Title(value),
      const SizedBox(width: Dimens.grid8),
      if (value.stopType == StopType.full) const _Tick.full() else const _Tick.short(),
      if (value.stopType != StopType.full) const SizedBox(width: Dimens.grid4),
    ];
    return Row(
      mainAxisAlignment: tickOnTheLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: tickOnTheLeft ? rowChildren.reversed.toList() : rowChildren,
    );
  }

  TextStyle labelTextStyle(BuildContext context) {
    switch (value.stopType) {
      case StopType.full:
        return Theme.of(context).textTheme.bodyLarge!;
      case StopType.half:
      case StopType.third:
        return Theme.of(context).textTheme.bodyMedium!;
    }
  }

  double tickLength() {
    switch (value.stopType) {
      case StopType.full:
        return Dimens.grid16;
      case StopType.half:
      case StopType.third:
        return Dimens.grid8;
    }
  }
}

class _Title<T extends PhotographyStopValue> extends StatelessWidget {
  final T value;
  late final String _title = value.toString();

  _Title(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: _title.length > 5 // downsize text only for long values like 1/4000
          ? AutoSizeText(
              value.toString(),
              stepGranularity: 0.5,
              minFontSize: 10,
              style: labelTextStyle(context).copyWith(color: Theme.of(context).colorScheme.onSurface),
              softWrap: false,
              overflow: TextOverflow.fade,
              maxLines: 1,
            )
          : Text(
              value.toString(),
              style: labelTextStyle(context).copyWith(color: Theme.of(context).colorScheme.onSurface),
              softWrap: false,
              overflow: TextOverflow.fade,
              maxLines: 1,
            ),
    );
  }

  TextStyle labelTextStyle(BuildContext context) {
    switch (value.stopType) {
      case StopType.full:
        return Theme.of(context).textTheme.bodyLarge!;
      case StopType.half:
      case StopType.third:
        return Theme.of(context).textTheme.bodyMedium!;
    }
  }
}

class _Tick extends StatelessWidget {
  final double _length;

  const _Tick.full() : _length = Dimens.grid16;
  const _Tick.short() : _length = Dimens.grid8;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.onSurface,
      child: SizedBox(
        height: 1,
        width: _length,
      ),
    );
  }
}
