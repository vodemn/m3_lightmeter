import 'package:flutter/gestures.dart';

abstract class CameraContainerEvent {
  const CameraContainerEvent();
}

class RequestPermissionEvent extends CameraContainerEvent {
  const RequestPermissionEvent();
}

class OpenAppSettingsEvent extends CameraContainerEvent {
  const OpenAppSettingsEvent();
}

class InitializeEvent extends CameraContainerEvent {
  const InitializeEvent();
}

class DeinitializeEvent extends CameraContainerEvent {
  const DeinitializeEvent();
}

class ZoomChangedEvent extends CameraContainerEvent {
  final double value;

  const ZoomChangedEvent(this.value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ZoomChangedEvent && other.value == value;
  }

  @override
  int get hashCode => Object.hash(value, runtimeType);
}

class ExposureOffsetChangedEvent extends CameraContainerEvent {
  final double value;

  const ExposureOffsetChangedEvent(this.value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ExposureOffsetChangedEvent && other.value == value;
  }

  @override
  int get hashCode => Object.hash(value, runtimeType);
}

class ExposureOffsetResetEvent extends CameraContainerEvent {
  const ExposureOffsetResetEvent();
}

class ExposureSpotChangedEvent extends CameraContainerEvent {
  final Offset offset;

  const ExposureSpotChangedEvent(this.offset);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is ExposureSpotChangedEvent && other.offset == offset;
  }

  @override
  int get hashCode => Object.hash(offset, runtimeType);
}
