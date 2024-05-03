import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/reading_value_container/widget_container_reading_value.dart';

class TimerMeteringConfig extends StatelessWidget {
  final ExposurePair exposurePair;

  const TimerMeteringConfig({
    required this.exposurePair,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
          ],
        ),
      ),
    );
  }
}
