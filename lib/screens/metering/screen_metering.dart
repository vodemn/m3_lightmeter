import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/photography_values/iso_value.dart';
import 'package:lightmeter/data/models/photography_values/nd_value.dart';
import 'package:lightmeter/data/models/photography_values/photography_value.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/providers/ev_source_type_provider.dart';

import 'components/bottom_controls/provider_bottom_controls.dart';
import 'components/camera_container/provider_container_camera.dart';
import 'components/light_sensor_container/provider_container_light_sensor.dart';
import 'bloc_metering.dart';
import 'event_metering.dart';
import 'state_metering.dart';

class MeteringScreen extends StatefulWidget {
  const MeteringScreen({super.key});

  @override
  State<MeteringScreen> createState() => _MeteringScreenState();
}

class _MeteringScreenState extends State<MeteringScreen> {
  MeteringBloc get _bloc => context.read<MeteringBloc>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc.add(StopTypeChangedEvent(context.watch<StopType>()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MeteringBloc, MeteringState>(
              buildWhen: (_, current) => current is MeteringDataState,
              builder: (_, state) => state is MeteringDataState
                  ? _MeteringContainerBuidler(
                      fastest: state.fastest,
                      slowest: state.slowest,
                      iso: state.iso,
                      nd: state.nd,
                      onIsoChanged: (value) => _bloc.add(IsoChangedEvent(value)),
                      onNdChanged: (value) => _bloc.add(NdChangedEvent(value)),
                      exposurePairs: state.exposurePairs,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          BlocBuilder<MeteringBloc, MeteringState>(
            builder: (context, state) => MeteringBottomControlsProvider(
              ev: state is MeteringDataState ? state.ev : null,
              isMetering: state is LoadingState || state is MeteringInProgressState,
              onSwitchEvSourceType: context.read<Environment>().hasLightSensor
                  ? EvSourceTypeProvider.of(context).toggleType
                  : null,
              onMeasure: () => _bloc.add(const MeasureEvent()),
              onSettings: () => Navigator.pushNamed(context, 'settings'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MeteringContainerBuidler extends StatelessWidget {
  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;
  final List<ExposurePair> exposurePairs;

  const _MeteringContainerBuidler({
    required this.fastest,
    required this.slowest,
    required this.iso,
    required this.nd,
    required this.onIsoChanged,
    required this.onNdChanged,
    required this.exposurePairs,
  });

  @override
  Widget build(BuildContext context) {
    return context.watch<EvSourceType>() == EvSourceType.camera
        ? CameraContainerProvider(
            fastest: fastest,
            slowest: slowest,
            iso: iso,
            nd: nd,
            onIsoChanged: onIsoChanged,
            onNdChanged: onNdChanged,
            exposurePairs: exposurePairs,
          )
        : LightSensorContainerProvider(
            fastest: fastest,
            slowest: slowest,
            iso: iso,
            nd: nd,
            onIsoChanged: onIsoChanged,
            onNdChanged: onNdChanged,
            exposurePairs: exposurePairs,
          );
  }
}
