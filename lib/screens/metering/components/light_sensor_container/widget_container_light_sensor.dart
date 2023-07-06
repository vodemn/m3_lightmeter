import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/shared/exposure_pairs_list/widget_list_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/metering_top_bar/widget_top_bar_metering.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/widget_container_readings.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class LightSensorContainer extends StatelessWidget {
  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final Film film;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<Film> onFilmChanged;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;
  final List<ExposurePair> exposurePairs;

  const LightSensorContainer({
    required this.fastest,
    required this.slowest,
    required this.film,
    required this.iso,
    required this.nd,
    required this.onFilmChanged,
    required this.onIsoChanged,
    required this.onNdChanged,
    required this.exposurePairs,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MeteringTopBar(
          readingsContainer: ReadingsContainer(
            fastest: fastest,
            slowest: slowest,
            film: film,
            iso: iso,
            nd: nd,
            onFilmChanged: onFilmChanged,
            onIsoChanged: onIsoChanged,
            onNdChanged: onNdChanged,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
            child: Center(child: ExposurePairsList(exposurePairs)),
          ),
        ),
      ],
    );
  }
}
