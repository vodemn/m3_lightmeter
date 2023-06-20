import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/environment.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/providers/ev_source_type_provider.dart';
import 'package:lightmeter/screens/metering/bloc_metering.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/provider_bottom_controls.dart';
import 'package:lightmeter/screens/metering/components/camera_container/provider_container_camera.dart';
import 'package:lightmeter/screens/metering/components/light_sensor_container/provider_container_light_sensor.dart';
import 'package:lightmeter/screens/metering/event_metering.dart';
import 'package:lightmeter/screens/metering/state_metering.dart';
import 'package:lightmeter/utils/inherited_generics.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class MeteringScreen extends StatelessWidget {
  const MeteringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _InheritedListeners(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<MeteringBloc, MeteringState>(
                builder: (_, state) => _MeteringContainerBuidler(
                  ev: state is MeteringDataState ? state.ev : null,
                  film: state.film,
                  iso: state.iso,
                  nd: state.nd,
                  onFilmChanged: (value) =>
                      context.read<MeteringBloc>().add(FilmChangedEvent(value)),
                  onIsoChanged: (value) => context.read<MeteringBloc>().add(IsoChangedEvent(value)),
                  onNdChanged: (value) => context.read<MeteringBloc>().add(NdChangedEvent(value)),
                ),
              ),
            ),
            BlocBuilder<MeteringBloc, MeteringState>(
              builder: (context, state) => MeteringBottomControlsProvider(
                ev: state is MeteringDataState ? state.ev : null,
                isMetering: state.isMetering,
                onSwitchEvSourceType: context.get<Environment>().hasLightSensor
                    ? EvSourceTypeProvider.of(context).toggleType
                    : null,
                onMeasure: () => context.read<MeteringBloc>().add(const MeasureEvent()),
                onSettings: () => Navigator.pushNamed(context, 'settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InheritedListeners extends StatelessWidget {
  final Widget child;

  const _InheritedListeners({required this.child});

  @override
  Widget build(BuildContext context) {
    return InheritedWidgetListener<EquipmentProfile>(
      onDidChangeDependencies: (value) {
        context.read<MeteringBloc>().add(EquipmentProfileChangedEvent(value));
      },
      child: InheritedModelAspectListener<MeteringScreenLayoutFeature, bool>(
        aspect: MeteringScreenLayoutFeature.filmPicker,
        onDidChangeDependencies: (value) {
          if (!value) context.read<MeteringBloc>().add(const FilmChangedEvent(Film.other()));
        },
        child: child,
      ),
    );
  }
}

class _MeteringContainerBuidler extends StatelessWidget {
  final double? ev;
  final Film film;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<Film> onFilmChanged;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;

  const _MeteringContainerBuidler({
    required this.ev,
    required this.film,
    required this.iso,
    required this.nd,
    required this.onFilmChanged,
    required this.onIsoChanged,
    required this.onNdChanged,
  });

  @override
  Widget build(BuildContext context) {
    final exposurePairs = ev != null ? buildExposureValues(context, ev!, film) : <ExposurePair>[];
    final fastest = exposurePairs.isNotEmpty ? exposurePairs.first : null;
    final slowest = exposurePairs.isNotEmpty ? exposurePairs.last : null;
    return context.listen<EvSourceType>() == EvSourceType.camera
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

  List<ExposurePair> buildExposureValues(BuildContext context, double ev, Film film) {
    if (ev.isNaN || ev.isInfinite) {
      return List.empty();
    }

    /// Depending on the `stopType` the exposure pairs list length is multiplied by 1,2 or 3
    final StopType stopType = context.listen<StopType>();
    final int evSteps = (ev * (stopType.index + 1)).round();

    final EquipmentProfile equipmentProfile = context.listen<EquipmentProfile>();
    final List<ApertureValue> apertureValues =
        equipmentProfile.apertureValues.whereStopType(stopType);
    final List<ShutterSpeedValue> shutterSpeedValues =
        equipmentProfile.shutterSpeedValues.whereStopType(stopType);

    /// Basically we use 1" shutter speed as an anchor point for building the exposure pairs list.
    /// But user can exclude this value from the list using custom equipment profile.
    /// So we have to restore the index of the anchor value.
    const ShutterSpeedValue anchorShutterSpeed = ShutterSpeedValue(1, false, StopType.full);
    int anchorIndex = shutterSpeedValues.indexOf(anchorShutterSpeed);
    if (anchorIndex < 0) {
      final filteredFullList = ShutterSpeedValue.values.whereStopType(stopType);
      final customListStartIndex = filteredFullList.indexOf(shutterSpeedValues.first);
      final fullListAnchor = filteredFullList.indexOf(anchorShutterSpeed);
      if (customListStartIndex < fullListAnchor) {
        /// This means, that user excluded anchor value at the end,
        /// i.e. all shutter speed values are shorter than 1".
        anchorIndex = fullListAnchor - customListStartIndex;
      } else {
        /// In case user excludes anchor value at the start,
        /// we can do no adjustment.
      }
    }
    final int evOffset = anchorIndex - evSteps;

    late final int apertureOffset;
    late final int shutterSpeedOffset;
    if (evOffset >= 0) {
      apertureOffset = 0;
      shutterSpeedOffset = evOffset;
    } else {
      apertureOffset = -evOffset;
      shutterSpeedOffset = 0;
    }

    final int itemsCount = min(
          apertureValues.length + shutterSpeedOffset,
          shutterSpeedValues.length + apertureOffset,
        ) -
        max(apertureOffset, shutterSpeedOffset);

    if (itemsCount < 0) {
      return List.empty();
    }
    return List.generate(
      itemsCount,
      (index) => ExposurePair(
        apertureValues[index + apertureOffset],
        film.reciprocityFailure(shutterSpeedValues[index + shutterSpeedOffset]),
      ),
      growable: false,
    );
  }
}
