abstract class CameraEvent {
  const CameraEvent();
}

class InitializeEvent extends CameraEvent {
  const InitializeEvent();
}

class ZoomChangedEvent extends CameraEvent {
  final double value;

  const ZoomChangedEvent(this.value);
}

class ExposureOffsetChangedEvent extends CameraEvent {
  final double value;

  const ExposureOffsetChangedEvent(this.value);
}
