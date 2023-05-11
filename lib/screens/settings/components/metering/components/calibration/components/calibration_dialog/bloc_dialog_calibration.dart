import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/settings_interactor.dart';

import 'package:lightmeter/screens/settings/components/metering/components/calibration/components/calibration_dialog/event_dialog_calibration.dart';
import 'package:lightmeter/screens/settings/components/metering/components/calibration/components/calibration_dialog/state_dialog_calibration.dart';

class CalibrationDialogBloc extends Bloc<CalibrationDialogEvent, CalibrationDialogState> {
  final SettingsInteractor _settingsInteractor;

  late double _cameraEvCalibration = _settingsInteractor.cameraEvCalibration;
  late double _lightSensorEvCalibration = _settingsInteractor.lightSensorEvCalibration;

  CalibrationDialogBloc(this._settingsInteractor)
      : super(
          CalibrationDialogState(
            _settingsInteractor.cameraEvCalibration,
            _settingsInteractor.lightSensorEvCalibration,
          ),
        ) {
    on<CameraEvCalibrationChangedEvent>(_onCameraEvCalibrationChanged);
    on<CameraEvCalibrationResetEvent>(_onCameraEvCalibrationReset);
    on<LightSensorEvCalibrationChangedEvent>(_onLightSensorEvCalibrationChanged);
    on<LightSensorEvCalibrationResetEvent>(_onLightSensorEvCalibrationReset);
    on<SaveCalibrationDialogEvent>(_onSaveCalibration);
  }

  void _onCameraEvCalibrationChanged(CameraEvCalibrationChangedEvent event, Emitter emit) {
    _cameraEvCalibration = event.value;
    emit(CalibrationDialogState(_cameraEvCalibration, _lightSensorEvCalibration));
  }

  void _onCameraEvCalibrationReset(CameraEvCalibrationResetEvent event, Emitter emit) {
    _settingsInteractor.quickVibration();
    _cameraEvCalibration = 0;
    emit(CalibrationDialogState(_cameraEvCalibration, _lightSensorEvCalibration));
  }

  void _onLightSensorEvCalibrationChanged(
      LightSensorEvCalibrationChangedEvent event, Emitter emit) {
    _lightSensorEvCalibration = event.value;
    emit(CalibrationDialogState(_cameraEvCalibration, _lightSensorEvCalibration));
  }

  void _onLightSensorEvCalibrationReset(LightSensorEvCalibrationResetEvent event, Emitter emit) {
    _settingsInteractor.quickVibration();
    _lightSensorEvCalibration = 0;
    emit(CalibrationDialogState(_cameraEvCalibration, _lightSensorEvCalibration));
  }

  void _onSaveCalibration(SaveCalibrationDialogEvent event, __) {
    _settingsInteractor.setCameraEvCalibration(_cameraEvCalibration);
    _settingsInteractor.setLightSensorEvCalibration(_lightSensorEvCalibration);
  }
}
