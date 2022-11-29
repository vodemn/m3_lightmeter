import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/models/exposure_pair.dart';
import 'package:lightmeter/res/dimens.dart';

import 'components/reading_container.dart';

class MeteringTopBar extends StatelessWidget {
  static const _columnsCount = 3;

  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final double ev;
  final int iso;
  final double nd;

  const MeteringTopBar({
    required this.fastest,
    required this.slowest,
    required this.ev,
    required this.iso,
    required this.nd,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final columnWidth =
        (MediaQuery.of(context).size.width - Dimens.paddingM * 2 - Dimens.grid16 * (_columnsCount - 1)) / 3;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(Dimens.borderRadiusL),
        bottomRight: Radius.circular(Dimens.borderRadiusL),
      ),
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.paddingM),
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: columnWidth / 3 * 4,
                        child: ReadingContainer(
                          values: [
                            ReadingValue(
                              label: S.of(context).fastestExposurePair,
                              value: fastest != null
                                  ? '${fastest!.aperture.toString()} - ${fastest!.shutterSpeed.toString()}'
                                  : 'N/A',
                            ),
                            ReadingValue(
                              label: S.of(context).slowestExposurePair,
                              value: fastest != null
                                  ? '${slowest!.aperture.toString()} - ${slowest!.shutterSpeed.toString()}'
                                  : 'N/A',
                            ),
                          ],
                        ),
                      ),
                      const _InnerPadding(),
                      Row(
                        children: [
                          SizedBox(
                            width: columnWidth,
                            child: ReadingContainer.singleValue(
                              value: ReadingValue(
                                label: 'EV',
                                value: ev.toStringAsFixed(1),
                              ),
                            ),
                          ),
                          const _InnerPadding(),
                          SizedBox(
                            width: columnWidth,
                            child: MediaQuery(
                              data: MediaQuery.of(context),
                              child: ReadingContainerWithDialog(
                                value: ReadingValue(
                                  label: 'ISO',
                                  value: iso.toString(),
                                ),
                                dialogBuilder: (context) => SizedBox(),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const _InnerPadding(),
                SizedBox(
                  width: columnWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimens.borderRadiusM),
                        child: const AspectRatio(
                          aspectRatio: 3 / 4,
                          child: ColoredBox(color: Colors.black),
                        ),
                      ),
                      const _InnerPadding(),
                      MediaQuery(
                        data: MediaQuery.of(context),
                        child: ReadingContainerWithDialog(
                          value: ReadingValue(
                            label: 'ND',
                            value: nd.toString(),
                          ),
                          dialogBuilder: (context) => SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InnerPadding extends SizedBox {
  const _InnerPadding() : super(height: Dimens.grid16, width: Dimens.grid16);
}
