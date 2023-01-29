import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/photography_values/iso_value.dart';
import 'package:lightmeter/data/models/photography_values/nd_value.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/metering/components/camera/components/camera_view/widget_camera_view.dart';
import 'package:lightmeter/screens/metering/components/shared/exposure_pairs_list/widget_list_exposure_pairs.dart';
import 'package:lightmeter/screens/metering/components/shared/metering_top_bar/widget_top_bar_metering.dart';
import 'package:lightmeter/screens/metering/components/shared/readings_container/widget_container_readings.dart';

import 'bloc_container_camera.dart';
import 'components/camera_controls/widget_camera_controls.dart';
import 'event_container_camera.dart';
import 'state_container_camera.dart';

// TODO: add stepHeight calculation based on Text
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
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingM),
            child: ExposurePairsList(exposurePairs),
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
      child: Center(
        child: BlocBuilder<CameraContainerBloc, CameraContainerState>(
          buildWhen: (previous, current) => current is CameraInitializedState,
          builder: (context, state) => state is CameraInitializedState
              ? CameraView(controller: state.controller)
              : const ColoredBox(color: Colors.black),
        ),
      ),
    );
  }
}

class _CameraControlsBuilder extends StatelessWidget {
  const _CameraControlsBuilder();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraContainerBloc, CameraContainerState>(
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
    );
  }
}
