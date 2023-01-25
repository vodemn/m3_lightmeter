import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';

import 'event_dialog_calibration.dart';
import 'state_dialog_calibration.dart';

class CalibrationDialogBloc extends Bloc<CalibrationDialogEvent, CalibrationDialogState> {
  final SettingsInteractor _settingsInteractor;

  late double _cameraEvCalibration = _settingsInteractor.cameraEvCalibration;

  CalibrationDialogBloc(this._settingsInteractor)
      : super(CalibrationDialogState(_settingsInteractor.cameraEvCalibration)) {
    on<CameraEvCalibrationChangedEvent>(_onCameraEvCalibrationChanged);
    on<CameraEvCalibrationResetEvent>(_onCameraEvCalibrationReset);
    on<SaveCalibrationDialogEvent>(_onSaveCalibration);
  }

  void _onCameraEvCalibrationChanged(CameraEvCalibrationChangedEvent event, Emitter emit) {
    _cameraEvCalibration = event.value;
    emit(CalibrationDialogState(event.value));
  }

  void _onCameraEvCalibrationReset(CameraEvCalibrationResetEvent event, Emitter emit) {
    _settingsInteractor.quickVibration();
    _cameraEvCalibration = 0;
    emit(CalibrationDialogState(_cameraEvCalibration));
  }

  void _onSaveCalibration(SaveCalibrationDialogEvent event, __) {
    _settingsInteractor.setCameraEvCalibration(_cameraEvCalibration);
  }
}
