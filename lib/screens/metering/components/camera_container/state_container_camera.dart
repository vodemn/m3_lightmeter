import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lightmeter/screens/metering/components/camera_container/models/camera_error_type.dart';

abstract class CameraContainerState {
  const CameraContainerState();
}

class CameraInitState extends CameraContainerState {
  const CameraInitState();
}

class CameraLoadingState extends CameraContainerState {
  const CameraLoadingState();
}

class CameraInitializedState extends CameraContainerState {
  final CameraController controller;

  const CameraInitializedState(this.controller);
}

class CameraActiveState extends CameraContainerState {
  final RangeValues zoomRange;
  final double currentZoom;
  final RangeValues exposureOffsetRange;
  final double? exposureOffsetStep;
  final double currentExposureOffset;

  const CameraActiveState({
    required this.zoomRange,
    required this.currentZoom,
    required this.exposureOffsetRange,
    required this.exposureOffsetStep,
    required this.currentExposureOffset,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is CameraActiveState &&
        other.zoomRange == zoomRange &&
        other.currentZoom == currentZoom &&
        other.exposureOffsetRange == exposureOffsetRange &&
        other.exposureOffsetStep == exposureOffsetStep &&
        other.currentExposureOffset == currentExposureOffset;
  }

  @override
  int get hashCode => Object.hash(
        runtimeType,
        zoomRange,
        currentZoom,
        exposureOffsetRange,
        exposureOffsetStep,
        currentExposureOffset,
      );
}

class CameraErrorState extends CameraContainerState {
  final CameraErrorType error;

  const CameraErrorState(this.error);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is CameraErrorState && other.error == error;
  }

  @override
  int get hashCode => Object.hash(error, runtimeType);
}
