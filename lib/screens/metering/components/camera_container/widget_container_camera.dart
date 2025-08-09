import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/feature.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/providers/remote_config_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/camera_container/bloc_container_camera.dart';
import 'package:lightmeter/screens/metering/components/camera_container/components/camera_controls/widget_camera_controls.dart';
import 'package:lightmeter/screens/metering/components/camera_container/components/camera_controls_placeholder/widget_placeholder_camera_controls.dart';
import 'package:lightmeter/screens/metering/components/camera_container/components/camera_preview/widget_camera_preview.dart';
import 'package:lightmeter/screens/metering/components/camera_container/event_container_camera.dart';
import 'package:lightmeter/screens/metering/components/camera_container/models/camera_error_type.dart';
import 'package:lightmeter/screens/metering/components/camera_container/state_container_camera.dart';
import 'package:lightmeter/screens/metering/components/shared/exposure_pairs_list/widget_list_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/metering_top_bar/widget_top_bar_metering.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/widget_container_readings.dart';
import 'package:lightmeter/utils/context_utils.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class CameraContainer extends StatelessWidget {
  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;
  final List<ExposurePair> exposurePairs;
  final ValueChanged<ExposurePair> onExposurePairTap;

  const CameraContainer({
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
    final double meteringContainerHeight = _meteringContainerHeight(context);
    final double cameraPreviewHeight = _cameraPreviewHeight(context);
    final double topBarOverflow = meteringContainerHeight - cameraPreviewHeight;

    return Stack(
      children: [
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          child: MeteringTopBar(
            readingsContainer: ReadingsContainer(
              fastest: fastest,
              slowest: slowest,
              iso: iso,
              nd: nd,
              onIsoChanged: onIsoChanged,
              onNdChanged: onNdChanged,
            ),
            appendixHeight: topBarOverflow,
            preview: const _CameraViewBuilder(),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Column(
            children: [
              SizedBox(
                height: min(meteringContainerHeight, cameraPreviewHeight) + Dimens.paddingM * 2,
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: Dimens.paddingM - Dimens.grid8,
                          top: topBarOverflow >= 0 ? topBarOverflow : 0,
                        ),
                        child: ExposurePairsList(
                          exposurePairs,
                          onExposurePairTap: onExposurePairTap,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width / 2 - Dimens.grid4,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: topBarOverflow <= 0 ? -topBarOverflow : 0,
                          right: Dimens.paddingM,
                        ),
                        child: const _CameraControlsBuilder(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _meteringContainerHeight(BuildContext context) {
    double enabledFeaturesHeight = 0;
    if (!context.isPro && RemoteConfig.isEnabled(context, Feature.showUnlockProOnMainScreen)) {
      enabledFeaturesHeight += Dimens.readingContainerSingleValueHeight;
      enabledFeaturesHeight += Dimens.paddingS;
    }
    if (context.meteringFeature(MeteringScreenLayoutFeature.equipmentProfiles)) {
      enabledFeaturesHeight += Dimens.readingContainerSingleValueHeight;
      enabledFeaturesHeight += Dimens.paddingS;
    }
    if (context.meteringFeature(MeteringScreenLayoutFeature.filmPicker)) {
      enabledFeaturesHeight += Dimens.readingContainerSingleValueHeight;
      enabledFeaturesHeight += Dimens.paddingS;
    }
    if (context.meteringFeature(MeteringScreenLayoutFeature.extremeExposurePairs)) {
      enabledFeaturesHeight += Dimens.readingContainerDoubleValueHeight;
      enabledFeaturesHeight += Dimens.paddingS;
    }

    return enabledFeaturesHeight + Dimens.readingContainerSingleValueHeight; // ISO & ND
  }

  double _cameraPreviewHeight(BuildContext context) {
    return ((MediaQuery.sizeOf(context).width - Dimens.grid8 - 2 * Dimens.paddingM) / 2) /
        PlatformConfig.cameraPreviewAspectRatio;
  }
}

class _CameraViewBuilder extends StatelessWidget {
  const _CameraViewBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraContainerBloc, CameraContainerState>(
      buildWhen: (previous, current) => current is! CameraActiveState,
      builder: (context, state) => CameraPreview(
        controller: state is CameraInitializedState ? state.controller : null,
        error: state is CameraErrorState ? state.error : null,
        onSpotTap: (value) {
          context.read<CameraContainerBloc>().add(ExposureSpotChangedEvent(value));
        },
      ),
    );
  }
}

class _CameraControlsBuilder extends StatelessWidget {
  const _CameraControlsBuilder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimens.paddingL,
        Dimens.paddingL,
        0,
        Dimens.paddingM,
      ),
      child: BlocBuilder<CameraContainerBloc, CameraContainerState>(
        builder: (context, state) {
          late final Widget child;
          if (state is CameraActiveState) {
            child = CameraControls(
              exposureOffsetRange: state.exposureOffsetRange,
              exposureOffsetValue: state.currentExposureOffset,
              onExposureOffsetChanged: (value) {
                context.read<CameraContainerBloc>().add(ExposureOffsetChangedEvent(value));
              },
              zoomRange: state.zoomRange,
              zoomValue: state.currentZoom,
              onZoomChanged: (value) {
                context.read<CameraContainerBloc>().add(ZoomChangedEvent(value));
              },
            );
          } else if (state is CameraErrorState) {
            child = CameraControlsPlaceholder(
              error: state.error,
              onReset: () {
                context.read<CameraContainerBloc>().add(
                      state.error == CameraErrorType.permissionNotGranted
                          ? const OpenAppSettingsEvent()
                          : const InitializeEvent(),
                    );
              },
            );
          } else {
            child = const Column(
              children: [Expanded(child: SizedBox.shrink())],
            );
          }

          return AnimatedSwitcher(
            duration: Dimens.switchDuration,
            child: child,
          );
        },
      ),
    );
  }
}
