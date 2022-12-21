import 'package:camera/camera.dart';

abstract class CameraState {
  const CameraState();
}

class CameraInitState extends CameraState {
  const CameraInitState();
}

class CameraLoadingState extends CameraState {
  const CameraLoadingState();
}

class CameraInitializedState extends CameraState {
  final CameraController controller;

  const CameraInitializedState(this.controller);
}

class CameraActiveState extends CameraState {
  final double minZoom;
  final double maxZoom;
  final double currentZoom;
  final double minExposureOffset;
  final double maxExposureOffset;
  final double? exposureOffsetStep;
  final double currentExposureOffset;

  const CameraActiveState({
    required this.minZoom,
    required this.maxZoom,
    required this.currentZoom,
    required this.minExposureOffset,
    required this.maxExposureOffset,
    required this.exposureOffsetStep,
    required this.currentExposureOffset,
  });
}

class CameraErrorState extends CameraState {
  const CameraErrorState();
}
