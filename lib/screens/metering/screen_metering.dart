import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/photography_values/photography_value.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/providers/ev_source_type_provider.dart';
import 'package:lightmeter/res/dimens.dart';

import 'components/bottom_controls/widget_bottom_controls.dart';
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
              builder: (context, state) => AnimatedSwitcher(
                duration: Dimens.durationS,
                child: context.watch<EvSourceType>() == EvSourceType.camera
                    ? CameraContainerProvider(
                        fastest: state.fastest,
                        slowest: state.slowest,
                        iso: state.iso,
                        nd: state.nd,
                        onIsoChanged: (value) => _bloc.add(IsoChangedEvent(value)),
                        onNdChanged: (value) => _bloc.add(NdChangedEvent(value)),
                        exposurePairs: state.exposurePairs,
                      )
                    : LightSensorContainerProvider(
                        fastest: state.fastest,
                        slowest: state.slowest,
                        iso: state.iso,
                        nd: state.nd,
                        onIsoChanged: (value) => _bloc.add(IsoChangedEvent(value)),
                        onNdChanged: (value) => _bloc.add(NdChangedEvent(value)),
                        exposurePairs: state.exposurePairs,
                      ),
              ),
            ),
          ),
          MeteringBottomControls(
            onSwitchEvSourceType: context.read<Environment>().hasLightSensor
                ? EvSourceTypeProvider.of(context).toggleType
                : null,
            onMeasure: () => _bloc.add(const MeasureEvent()),
            onSettings: () => Navigator.pushNamed(context, 'settings'),
          ),
        ],
      ),
    );
  }
}
