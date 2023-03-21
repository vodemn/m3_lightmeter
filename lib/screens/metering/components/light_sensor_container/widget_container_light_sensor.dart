import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/shared/exposure_pairs_list/widget_list_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/metering_top_bar/widget_top_bar_metering.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/widget_container_readings.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class LightSensorContainer extends StatelessWidget {
  final ValueChanged<EquipmentProfileData> onEquipmentProfileChanged;
  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final List<IsoValue> isoValues;
  final IsoValue iso;
  final List<NdValue> ndValues;
  final NdValue nd;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;
  final List<ExposurePair> exposurePairs;

  const LightSensorContainer({
    required this.onEquipmentProfileChanged,
    required this.fastest,
    required this.slowest,
    required this.isoValues,
    required this.iso,
    required this.ndValues,
    required this.nd,
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
            onEquipmentProfileChanged: onEquipmentProfileChanged,
            fastest: fastest,
            slowest: slowest,
            isoValues: isoValues,
            iso: iso,
            ndValues: ndValues,
            nd: nd,
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
