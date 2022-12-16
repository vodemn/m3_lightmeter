import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/exposure_pairs_list/components/exposure_pair_item.dart';

class ExposurePairsList extends StatelessWidget {
  final List<ExposurePair> exposurePairs;

  const ExposurePairsList(this.exposurePairs, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: ListView.builder(
            key: ValueKey(exposurePairs.hashCode),
            itemCount: exposurePairs.length,
            itemBuilder: (_, index) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ExposurePaitListItem(
                      exposurePairs[index].aperture,
                      tickOnTheLeft: false,
                    ),
                  ),
                ),
                const SizedBox(width: Dimens.grid16),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ExposurePaitListItem(
                      exposurePairs[index].shutterSpeed,
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
