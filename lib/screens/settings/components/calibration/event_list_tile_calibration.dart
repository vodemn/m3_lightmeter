abstract class CalibrationEvent {
  const CalibrationEvent();
}

class CameraEvCalibrationChangedEvent extends CalibrationEvent {
  final double value;

  const CameraEvCalibrationChangedEvent(this.value);
}
