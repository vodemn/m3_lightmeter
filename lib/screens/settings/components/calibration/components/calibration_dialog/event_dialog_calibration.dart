abstract class CalibrationDialogEvent {
  const CalibrationDialogEvent();
}

class CameraEvCalibrationChangedEvent extends CalibrationDialogEvent {
  final double value;

  const CameraEvCalibrationChangedEvent(this.value);
}

class CameraEvCalibrationResetEvent extends CalibrationDialogEvent {
  const CameraEvCalibrationResetEvent();
}

class LightSensorEvCalibrationChangedEvent extends CalibrationDialogEvent {
  final double value;

  const LightSensorEvCalibrationChangedEvent(this.value);
}

class LightSensorEvCalibrationResetEvent extends CalibrationDialogEvent {
  const LightSensorEvCalibrationResetEvent();
}

class SaveCalibrationDialogEvent extends CalibrationDialogEvent {
  const SaveCalibrationDialogEvent();
}
