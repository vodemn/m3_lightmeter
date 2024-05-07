import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/shared/exposure_pairs_list/components/exposure_pairs_list_item/widget_item_list_exposure_pairs.dart';
import 'package:lightmeter/screens/shared/icon_placeholder/widget_icon_placeholder.dart';
import 'package:lightmeter/utils/context_utils.dart';

class ExposurePairsList extends StatelessWidget {
  final List<ExposurePair> exposurePairs;
  final ValueChanged<ExposurePair> onExposurePairTap;

  const ExposurePairsList(this.exposurePairs, {required this.onExposurePairTap, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Dimens.switchDuration,
      child: exposurePairs.isEmpty
          ? IconPlaceholder(
              icon: Icons.not_interested,
              text: S.of(context).noExposurePairs,
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: ListView.builder(
                    key: ValueKey(exposurePairs.hashCode),
                    padding: const EdgeInsets.symmetric(vertical: Dimens.paddingL),
                    itemCount: exposurePairs.length,
                    itemBuilder: (_, index) {
                      final exposurePair = ExposurePair(
                        exposurePairs[index].aperture,
                        Films.selectedOf(context).reciprocityFailure(exposurePairs[index].shutterSpeed),
                      );
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          GestureDetector(
                            onTap: context.isPro ? () => onExposurePairTap(exposurePair) : null,
                            child: Row(
                              key: ValueKey(index),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: ExposurePairsListItem(
                                      exposurePair.aperture,
                                      tickOnTheLeft: false,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: ExposurePairsListItem(
                                      exposurePair.shutterSpeed,
                                      tickOnTheLeft: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            bottom: 0,
                            child: LayoutBuilder(
                              builder: (context, constraints) => Align(
                                alignment: index == 0
                                    ? Alignment.bottomCenter
                                    : (index == exposurePairs.length - 1 ? Alignment.topCenter : Alignment.center),
                                child: SizedBox(
                                  height: index == 0 || index == exposurePairs.length - 1
                                      ? constraints.maxHeight / 2
                                      : constraints.maxHeight,
                                  child: ColoredBox(
                                    color: Theme.of(context).colorScheme.onBackground,
                                    child: const SizedBox(width: 1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
