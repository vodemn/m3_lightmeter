import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/photography_values/iso_value.dart';
import 'package:lightmeter/data/models/photography_values/nd_value.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';

import 'bloc_container_light_sensor.dart';
import 'widget_container_light_sensor.dart';

class LightSensorContainerProvider extends StatelessWidget {
  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;
  final List<ExposurePair> exposurePairs;

  const LightSensorContainerProvider({
    required this.fastest,
    required this.slowest,
    required this.iso,
    required this.nd,
    required this.onIsoChanged,
    required this.onNdChanged,
    required this.exposurePairs,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => LightSensorContainerBloc(
        context.read<MeteringInteractor>(),
        context.read<MeteringCommunicationBloc>(),
      ),
      child: LightSensorContainer(
        fastest: fastest,
        slowest: slowest,
        isoValues: EquipmentProfile.of(context)?.isoValues ?? isoValues,
        iso: iso,
        ndValues: EquipmentProfile.of(context)?.ndValues ?? ndValues,
        nd: nd,
        onIsoChanged: onIsoChanged,
        onNdChanged: onNdChanged,
        exposurePairs: exposurePairs,
      ),
    );
  }
}
