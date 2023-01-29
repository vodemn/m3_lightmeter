abstract class CameraContainerEvent {
  const CameraContainerEvent();
}

class InitializeEvent extends CameraContainerEvent {
  const InitializeEvent();
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
