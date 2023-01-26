import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/screens/metering/ev_source/camera/bloc_camera.dart';
import 'package:lightmeter/screens/metering/ev_source/camera/state_camera.dart';

class CameraView extends StatelessWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: PlatformConfig.cameraPreviewAspectRatio,
      child: Center(
        child: BlocBuilder<CameraBloc, CameraState>(
          buildWhen: (previous, current) => current is CameraInitializedState,
          builder: (context, state) {
            if (state is CameraInitializedState) {
              final value = state.controller.value;
              return ValueListenableBuilder<CameraValue>(
                valueListenable: state.controller,
                builder: (_, __, ___) => AspectRatio(
                  aspectRatio: _isLandscape(value) ? value.aspectRatio : (1 / value.aspectRatio),
                  child: RotatedBox(
                    quarterTurns: _getQuarterTurns(value),
                    child: state.controller.buildPreview(),
                  ),
                ),
              );
            }
            return const ColoredBox(color: Colors.black);
          },
        ),
      ),
    );
  }

  bool _isLandscape(CameraValue value) {
    return <DeviceOrientation>[DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
        .contains(_getApplicableOrientation(value));
  }

  int _getQuarterTurns(CameraValue value) {
    final Map<DeviceOrientation, int> turns = <DeviceOrientation, int>{
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeRight: 1,
      DeviceOrientation.portraitDown: 2,
      DeviceOrientation.landscapeLeft: 3,
    };
    return turns[_getApplicableOrientation(value)]!;
  }

  DeviceOrientation _getApplicableOrientation(CameraValue value) {
    return value.isRecordingVideo
        ? value.recordingOrientation!
        : (value.previewPauseOrientation ??
            value.lockedCaptureOrientation ??
            value.deviceOrientation);
  }
}
