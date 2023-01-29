import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraView extends StatelessWidget {
  final CameraController controller;

  const CameraView({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = controller.value;
    return ValueListenableBuilder<CameraValue>(
      valueListenable: controller,
      builder: (_, __, ___) => AspectRatio(
        aspectRatio: _isLandscape(value) ? value.aspectRatio : (1 / value.aspectRatio),
        child: RotatedBox(
          quarterTurns: _getQuarterTurns(value),
          child: controller.buildPreview(),
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
