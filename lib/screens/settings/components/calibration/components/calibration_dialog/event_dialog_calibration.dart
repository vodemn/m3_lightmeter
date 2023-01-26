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

class SaveCalibrationDialogEvent extends CalibrationDialogEvent {
  const SaveCalibrationDialogEvent();
}
