import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/providers/films_provider.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/components/shared/reading_value_container/widget_container_reading_value.dart';

class ExtremeExposurePairsContainer extends StatelessWidget {
  final ExposurePair? fastest;
  final ExposurePair? slowest;

  const ExtremeExposurePairsContainer({
    required this.fastest,
    required this.slowest,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ReadingValueContainer(
      values: [
        ReadingValue(
          label: S.of(context).fastestExposurePair,
          value: _exposurePairToString(context, fastest),
        ),
        ReadingValue(
          label: S.of(context).slowestExposurePair,
          value: _exposurePairToString(context, slowest),
        ),
      ],
    );
  }

  String _exposurePairToString(BuildContext context, ExposurePair? pair) {
    if (pair == null) {
      return '-';
    }

    return '${pair.aperture} - ${Films.selectedOf(context).reciprocityFailure(pair.shutterSpeed)}';
  }
}
