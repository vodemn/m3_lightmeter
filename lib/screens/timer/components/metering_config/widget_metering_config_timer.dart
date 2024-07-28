import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/res/theme.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/reading_value_container/widget_container_reading_value.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class TimerMeteringConfig extends StatelessWidget {
  final ExposurePair exposurePair;
  final IsoValue isoValue;
  final NdValue ndValue;

  const TimerMeteringConfig({
    required this.exposurePair,
    required this.isoValue,
    required this.ndValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceElevated1,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(Dimens.borderRadiusL),
          bottomRight: Radius.circular(Dimens.borderRadiusL),
        ),
      ),
      padding: const EdgeInsets.all(Dimens.paddingM),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Expanded(
              child: ReadingValueContainer.singleValue(
                value: ReadingValue(
                  label: S.of(context).exposurePair,
                  value: exposurePair.toString(),
                ),
              ),
            ),
            const SizedBox(width: Dimens.grid8),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ReadingValueContainer.singleValue(
                      value: ReadingValue(
                        label: S.of(context).iso,
                        value: isoValue.toString(),
                      ),
                      locked: true,
                    ),
                  ),
                  const SizedBox(width: Dimens.grid8),
                  Expanded(
                    child: ReadingValueContainer.singleValue(
                      value: ReadingValue(
                        label: S.of(context).nd,
                        value: ndValue.value == 0 ? S.of(context).none : ndValue.value.toString(),
                      ),
                      locked: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
