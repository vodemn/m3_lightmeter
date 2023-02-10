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

class ReinitializeEvent extends CameraContainerEvent {
  const ReinitializeEvent();
}

class ZoomChangedEvent extends CameraContainerEvent {
  final double value;

  const ZoomChangedEvent(this.value);
}

class ExposureOffsetChangedEvent extends CameraContainerEvent {
  final double value;

  const ExposureOffsetChangedEvent(this.value);
}

class ExposureOffsetResetEvent extends CameraContainerEvent {
  const ExposureOffsetResetEvent();
}
