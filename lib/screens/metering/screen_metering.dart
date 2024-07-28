import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/providers/user_preferences_provider.dart';
import 'package:lightmeter/screens/metering/bloc_metering.dart';
import 'package:lightmeter/screens/metering/components/bottom_controls/widget_bottom_controls.dart';
import 'package:lightmeter/screens/metering/components/camera_container/provider_container_camera.dart';
import 'package:lightmeter/screens/metering/components/light_sensor_container/provider_container_light_sensor.dart';
import 'package:lightmeter/screens/metering/event_metering.dart';
import 'package:lightmeter/screens/metering/state_metering.dart';
import 'package:lightmeter/screens/metering/utils/listener_equipment_profiles.dart';
import 'package:lightmeter/screens/timer/flow_timer.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class MeteringScreen extends StatelessWidget {
  const MeteringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _InheritedListeners(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<MeteringBloc, MeteringState>(
                builder: (_, state) => MeteringContainerBuidler(
                  ev: state is MeteringDataState ? state.ev : null,
                  iso: state.iso,
                  nd: state.nd,
                  onIsoChanged: (value) => context.read<MeteringBloc>().add(IsoChangedEvent(value)),
                  onNdChanged: (value) => context.read<MeteringBloc>().add(NdChangedEvent(value)),
                  onExposurePairTap: (value) => pushNamed(
                    context,
                    'timer',
                    arguments: TimerFlowArgs(
                      exposurePair: value,
                      isoValue: state.iso,
                      ndValue: state.nd,
                    ),
                  ),
                ),
              ),
            ),
            BlocBuilder<MeteringBloc, MeteringState>(
              builder: (context, state) => MeteringBottomControls(
                ev: state is MeteringDataState ? state.ev : null,
                ev100: state is MeteringDataState ? state.ev100 : null,
                isMetering: state.isMetering,
                onSwitchEvSourceType: ServicesProvider.of(context).environment.hasLightSensor
                    ? UserPreferencesProvider.of(context).toggleEvSourceType
                    : null,
                onMeasure: () => context.read<MeteringBloc>().add(const MeasureEvent()),
                onSettings: () => pushNamed(context, 'settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pushNamed(BuildContext context, String routeName, {Object? arguments}) {
    context.read<MeteringBloc>().add(const ScreenOnTopOpenedEvent());
    Navigator.pushNamed(context, routeName, arguments: arguments).then((_) {
      context.read<MeteringBloc>().add(const ScreenOnTopClosedEvent());
    });
  }
}

class _InheritedListeners extends StatelessWidget {
  final Widget child;

  const _InheritedListeners({required this.child});

  @override
  Widget build(BuildContext context) {
    return EquipmentProfileListener(
      onDidChangeDependencies: (value) {
        context.read<MeteringBloc>().add(EquipmentProfileChangedEvent(value));
      },
      child: child,
    );
  }
}

class MeteringContainerBuidler extends StatelessWidget {
  final double? ev;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;
  final ValueChanged<ExposurePair> onExposurePairTap;

  const MeteringContainerBuidler({
    required this.ev,
    required this.iso,
    required this.nd,
    required this.onIsoChanged,
    required this.onNdChanged,
    required this.onExposurePairTap,
  });

  @override
  Widget build(BuildContext context) {
    final exposurePairs = ev != null
        ? buildExposureValues(
            ev!,
            UserPreferencesProvider.stopTypeOf(context),
            EquipmentProfiles.selectedOf(context),
          )
        : <ExposurePair>[];
    final fastest = exposurePairs.isNotEmpty ? exposurePairs.first : null;
    final slowest = exposurePairs.isNotEmpty ? exposurePairs.last : null;
    // Doubled build here when switching evSourceType. As new source bloc fires a new state on init
    return UserPreferencesProvider.evSourceTypeOf(context) == EvSourceType.camera
        ? CameraContainerProvider(
            fastest: fastest,
            slowest: slowest,
            iso: iso,
            nd: nd,
            onIsoChanged: onIsoChanged,
            onNdChanged: onNdChanged,
            exposurePairs: exposurePairs,
            onExposurePairTap: onExposurePairTap,
          )
        : LightSensorContainerProvider(
            fastest: fastest,
            slowest: slowest,
            iso: iso,
            nd: nd,
            onIsoChanged: onIsoChanged,
            onNdChanged: onNdChanged,
            exposurePairs: exposurePairs,
            onExposurePairTap: onExposurePairTap,
          );
  }

  @visibleForTesting
  static List<ExposurePair> buildExposureValues(
    double ev,
    StopType stopType,
    EquipmentProfile equipmentProfile,
  ) {
    if (ev.isNaN || ev.isInfinite) {
      return List.empty();
    }

    /// Depending on the `stopType` the exposure pairs list length is multiplied by 1,2 or 3
    final int evSteps = (ev * (stopType.index + 1)).round();

    final apertureValues = ApertureValue.values.whereStopType(stopType);
    final shutterSpeedValues = ShutterSpeedValue.values.whereStopType(stopType);

    /// Basically we use 1" shutter speed as an anchor point for building the exposure pairs list.
    /// But user can exclude this value from the list using custom equipment profile.
    /// So we have to restore the index of the anchor value.
    const anchorShutterSpeed = ShutterSpeedValue(1, false, StopType.full);
    final int anchorIndex = shutterSpeedValues.indexOf(anchorShutterSpeed);
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

    int itemsCount = min(
          apertureValues.length + shutterSpeedOffset,
          shutterSpeedValues.length + apertureOffset,
        ) -
        max(apertureOffset, shutterSpeedOffset);

    if (apertureOffset == apertureValues.length) {
      return List.empty();
    }

    final lastPreCalcShutterSpeed =
        shutterSpeedValues.elementAtOrNull(itemsCount - 1 + shutterSpeedOffset) ?? shutterSpeedValues.last;
    final preCalculatedItemsCount = itemsCount;
    if (itemsCount <= 0) {
      itemsCount = apertureValues.length;
    } else {
      itemsCount += (apertureValues.length - 1) - (itemsCount - 1 + apertureOffset);
    }

    final exposurePairs = List.generate(
      itemsCount,
      (index) {
        final stopDifference = (index - (preCalculatedItemsCount - 1)) / (stopType.index + 1);
        final newShutterSpeed = log2(lastPreCalcShutterSpeed.rawValue) + stopDifference;
        return ExposurePair(
          apertureValues[index + apertureOffset],
          shutterSpeedValues.elementAtOrNull(index + shutterSpeedOffset) ??
              ShutterSpeedValue(
                calcShutterSpeed(newShutterSpeed),
                false,
                stopDifference == stopDifference.roundToDouble() ? StopType.full : stopType,
              ),
        );
      },
      growable: false,
    );

    /// Full equipment profile, nothing to cut
    if (equipmentProfile.id == "") {
      return exposurePairs;
    }

    final equipmentApertureValues = equipmentProfile.apertureValues.whereStopType(stopType);
    final equipmentShutterSpeedValues = equipmentProfile.shutterSpeedValues.whereStopType(stopType);

    final startCutEV = max(
      exposurePairs.first.aperture.difference(equipmentApertureValues.first),
      exposurePairs.first.shutterSpeed.difference(equipmentShutterSpeedValues.first),
    );
    final endCutEV = max(
      equipmentApertureValues.last.difference(exposurePairs.last.aperture),
      equipmentShutterSpeedValues.last != ShutterSpeedValue.values.last
          ? equipmentShutterSpeedValues.last.difference(exposurePairs.last.shutterSpeed)
          : double.negativeInfinity,
    );

    final startCut = (startCutEV * (stopType.index + 1)).round().clamp(0, itemsCount);
    final endCut = (endCutEV * (stopType.index + 1)).round().clamp(0, itemsCount);

    if (startCut > itemsCount - endCut) {
      return const [];
    }
    return exposurePairs.sublist(startCut, itemsCount - endCut);
  }
}

double calcShutterSpeed(double stopValue) {
  final shutterSpeed = pow(2, stopValue);
  if (stopValue < 1.5) {
    return (shutterSpeed * 10).round() / 10;
  } else {
    return shutterSpeed.roundToDouble();
  }
}
