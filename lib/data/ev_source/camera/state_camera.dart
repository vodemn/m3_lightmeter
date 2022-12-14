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

class CameraReadyState extends CameraState {
  final CameraController controller;

  const CameraReadyState(this.controller);
}

class CameraErrorState extends CameraState {
  const CameraErrorState();
}
