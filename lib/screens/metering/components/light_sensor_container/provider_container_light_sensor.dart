import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/components/light_sensor_container/bloc_container_light_sensor.dart';
import 'package:lightmeter/screens/metering/components/light_sensor_container/widget_container_light_sensor.dart';
import 'package:lightmeter/screens/metering/flow_metering.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class LightSensorContainerProvider extends StatelessWidget {
  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;
  final List<ExposurePair> exposurePairs;
  final ValueChanged<ShutterSpeedValue> onExposurePairTap;

  const LightSensorContainerProvider({
    required this.fastest,
    required this.slowest,
    required this.iso,
    required this.nd,
    required this.onIsoChanged,
    required this.onNdChanged,
    required this.exposurePairs,
    required this.onExposurePairTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => LightSensorContainerBloc(
        MeteringInteractorProvider.of(context),
        context.read<MeteringCommunicationBloc>(),
      ),
      child: LightSensorContainer(
        fastest: fastest,
        slowest: slowest,
        iso: iso,
        nd: nd,
        onIsoChanged: onIsoChanged,
        onNdChanged: onNdChanged,
        exposurePairs: exposurePairs,
        onExposurePairTap: onExposurePairTap,
      ),
    );
  }
}
