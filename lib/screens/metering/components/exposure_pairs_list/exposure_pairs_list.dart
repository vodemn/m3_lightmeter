import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lightmeter/models/photography_value.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/exposure_pairs_list/components/exposure_pair_item.dart';

class ExposurePairsList extends StatelessWidget {
  final double ev;
  final Stop stopType;
  final List<ApertureValue> _apertureValuesList;
  final List<ShutterSpeedValue> _shutterSpeedValuesList;
  late final int _apertureOffset;
  late final int _shutterSpeedOffset;
  late final int _itemsCount;

  ExposurePairsList({
    required this.ev,
    required this.stopType,
    super.key,
  })  : _apertureValuesList = apertureValues.whereStopType(stopType),
        _shutterSpeedValuesList = shutterSpeedValues.whereStopType(stopType) {
    late final int evSteps;
    switch (stopType) {
      case Stop.full:
        evSteps = ev.floor();
        break;
      case Stop.half:
        evSteps = (ev / 0.5).floor();
        break;
      case Stop.third:
        evSteps = (ev / 0.3).floor();
        break;
    }

    final evOffset = _shutterSpeedValuesList.indexOf(const ShutterSpeedValue(1, false, Stop.full)) - evSteps;
    if (evOffset >= 0) {
      _apertureOffset = 0;
      _shutterSpeedOffset = evOffset;
    } else {
      _apertureOffset = -evOffset;
      _shutterSpeedOffset = 0;
    }

    _itemsCount = min(
          _apertureValuesList.length + _shutterSpeedOffset,
          _shutterSpeedValuesList.length + _apertureOffset,
        ) -
        max(
          _apertureOffset,
          _shutterSpeedOffset,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: ListView.builder(
            itemCount: _itemsCount,
            itemBuilder: (_, index) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ExposurePaitListItem(
                      _apertureValuesList[index + _apertureOffset],
                      tickOnTheLeft: false,
                    ),
                  ),
                ),
                const SizedBox(width: Dimens.grid16),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ExposurePaitListItem(
                      _shutterSpeedValuesList[index + _shutterSpeedOffset],
                      tickOnTheLeft: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          child: ColoredBox(
            color: Theme.of(context).colorScheme.onBackground,
            child: const SizedBox(width: 1),
          ),
        ),
      ],
    );
  }
}
