import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/providers/ev_source_type_provider.dart';
import 'package:lightmeter/providers/metering_screen_layout_provider.dart';
import 'package:lightmeter/screens/metering/bloc_metering.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/provider_bottom_controls.dart';
import 'package:lightmeter/screens/metering/components/camera_container/provider_container_camera.dart';
import 'package:lightmeter/screens/metering/components/light_sensor_container/provider_container_light_sensor.dart';
import 'package:lightmeter/screens/metering/event_metering.dart';
import 'package:lightmeter/screens/metering/state_metering.dart';
import 'package:lightmeter/utils/inherited_generics.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

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
    _bloc.add(EquipmentProfileChangedEvent(EquipmentProfile.of(context)));
    if (!MeteringScreenLayout.featureStatusOf(context, MeteringScreenLayoutFeature.filmPicker)) {
      _bloc.add(const FilmChangedEvent(Film.other()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedWidgetListener<StopType>(
      onDidChangeDependencies: (value) {
        context.read<MeteringBloc>().add(StopTypeChangedEvent(value));
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<MeteringBloc, MeteringState>(
                builder: (_, state) => _MeteringContainerBuidler(
                  fastest: state is MeteringDataState ? state.fastest : null,
                  slowest: state is MeteringDataState ? state.slowest : null,
                  exposurePairs: state is MeteringDataState ? state.exposurePairs : [],
                  film: state.film,
                  iso: state.iso,
                  nd: state.nd,
                  onFilmChanged: (value) => _bloc.add(FilmChangedEvent(value)),
                  onIsoChanged: (value) => _bloc.add(IsoChangedEvent(value)),
                  onNdChanged: (value) => _bloc.add(NdChangedEvent(value)),
                ),
              ),
            ),
            BlocBuilder<MeteringBloc, MeteringState>(
              builder: (context, state) => MeteringBottomControlsProvider(
                ev: state is MeteringDataState ? state.ev : null,
                isMetering:
                    state is LoadingState || state is MeteringDataState && state.continuousMetering,
                hasError: state is MeteringDataState && state.hasError,
                onSwitchEvSourceType: context.read<Environment>().hasLightSensor
                    ? EvSourceTypeProvider.of(context).toggleType
                    : null,
                onMeasure: () => _bloc.add(const MeasureEvent()),
                onSettings: () => Navigator.pushNamed(context, 'settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MeteringContainerBuidler extends StatelessWidget {
  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final Film film;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<Film> onFilmChanged;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;
  final List<ExposurePair> exposurePairs;

  const _MeteringContainerBuidler({
    required this.fastest,
    required this.slowest,
    required this.film,
    required this.iso,
    required this.nd,
    required this.onFilmChanged,
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
            film: film,
            iso: iso,
            nd: nd,
            onFilmChanged: onFilmChanged,
            onIsoChanged: onIsoChanged,
            onNdChanged: onNdChanged,
            exposurePairs: exposurePairs,
          )
        : LightSensorContainerProvider(
            fastest: fastest,
            slowest: slowest,
            film: film,
            iso: iso,
            nd: nd,
            onFilmChanged: onFilmChanged,
            onIsoChanged: onIsoChanged,
            onNdChanged: onNdChanged,
            exposurePairs: exposurePairs,
          );
  }
}
