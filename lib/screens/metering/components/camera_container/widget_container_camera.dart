import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/photography_values/iso_value.dart';
import 'package:lightmeter/data/models/photography_values/nd_value.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/camera_container/components/camera_view/widget_camera_view.dart';
import 'package:lightmeter/screens/metering/components/shared/exposure_pairs_list/widget_list_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/metering_top_bar/widget_top_bar_metering.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/widget_container_readings.dart';

import 'bloc_container_camera.dart';
import 'components/camera_controls/widget_camera_controls.dart';
import 'components/camera_view_placeholder/widget_placeholder_camera_view.dart';
import 'event_container_camera.dart';
import 'state_container_camera.dart';

class CameraContainer extends StatelessWidget {
  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;
  final List<ExposurePair> exposurePairs;

  const CameraContainer({
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
    final topBarOverflow = Dimens.readingContainerHeight -
        ((MediaQuery.of(context).size.width - Dimens.grid8 - 2 * Dimens.paddingM) / 2) /
            PlatformConfig.cameraPreviewAspectRatio;
    return Column(
      children: [
        MeteringTopBar(
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
  const _CameraViewBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: PlatformConfig.cameraPreviewAspectRatio,
      child: BlocBuilder<CameraContainerBloc, CameraContainerState>(
        buildWhen: (previous, current) => current is CameraInitializedState,
        builder: (context, state) => state is CameraInitializedState
            ? Center(child: CameraView(controller: state.controller))
            : const CameraViewPlaceholder(),
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
        builder: (context, state) => AnimatedSwitcher(
          duration: Dimens.durationS,
          child: state is CameraActiveState
              ? CameraControls(
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
                )
              : const SizedBox.shrink(),
        ),
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
