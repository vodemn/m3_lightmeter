import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:lightmeter/data/models/metering_screen_layout_config.dart';
import 'package:lightmeter/features.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/providers/metering_screen_layout_provider.dart';
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
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class CameraContainer extends StatelessWidget {
  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final Film film;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<Film> onFilmChanged;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;
  final List<ExposurePair> exposurePairs;

  const CameraContainer({
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
    final double cameraViewHeight =
        ((MediaQuery.of(context).size.width - Dimens.grid8 - 2 * Dimens.paddingM) / 2) /
            PlatformConfig.cameraPreviewAspectRatio;

    double topBarOverflow = Dimens.readingContainerSingleValueHeight + // ISO & ND
        -cameraViewHeight;
    if (FeaturesConfig.equipmentProfilesEnabled) {
      topBarOverflow += Dimens.readingContainerSingleValueHeight;
      topBarOverflow += Dimens.paddingS;
    }
    if (MeteringScreenLayout.featureOf(
      context,
      MeteringScreenLayoutFeature.extremeExposurePairs,
    )) {
      topBarOverflow += Dimens.readingContainerDoubleValueHeight;
      topBarOverflow += Dimens.paddingS;
    }
    if (MeteringScreenLayout.featureOf(
      context,
      MeteringScreenLayoutFeature.filmPicker,
    )) {
      topBarOverflow += Dimens.readingContainerSingleValueHeight;
      topBarOverflow += Dimens.paddingS;
    }

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
          appendixHeight: topBarOverflow,
          preview: const _CameraViewBuilder(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
            child: _MiddleContentWrapper(
              topBarOverflow: topBarOverflow,
              leftContent: ExposurePairsList(exposurePairs),
              rightContent: const _CameraControlsBuilder(),
            ),
          ),
        ),
      ],
    );
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
      ),
    );
  }
}

class _CameraControlsBuilder extends StatelessWidget {
  const _CameraControlsBuilder();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimens.paddingM),
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

class _MiddleContentWrapper extends StatelessWidget {
  final double topBarOverflow;
  final Widget leftContent;
  final Widget rightContent;

  const _MiddleContentWrapper({
    required this.topBarOverflow,
    required this.leftContent,
    required this.rightContent,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => OverflowBox(
        alignment: Alignment.bottomCenter,
        maxHeight: constraints.maxHeight + topBarOverflow.abs(),
        maxWidth: constraints.maxWidth,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: topBarOverflow >= 0 ? topBarOverflow : 0),
                child: leftContent,
              ),
            ),
            const SizedBox(width: Dimens.grid8),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: topBarOverflow <= 0 ? -topBarOverflow : 0),
                child: rightContent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
