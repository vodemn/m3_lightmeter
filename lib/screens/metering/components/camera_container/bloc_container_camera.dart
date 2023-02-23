import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/screens/metering/components/camera_container/models/camera_error_type.dart';
import 'package:lightmeter/screens/metering/components/shared/ev_source_base/bloc_base_ev_source.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/communication/event_communication_metering.dart'
    as communication_event;
import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart'
    as communication_states;
import 'package:lightmeter/utils/log_2.dart';

import 'event_container_camera.dart';
import 'state_container_camera.dart';

class CameraContainerBloc extends EvSourceBlocBase<CameraContainerEvent, CameraContainerState> {
  final MeteringInteractor _meteringInteractor;
  late final _WidgetsBindingObserver _observer;
  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;

  static const _maxZoom = 7.0;
  RangeValues? _zoomRange;
  double _currentZoom = 0.0;

  static const _exposureMaxRange = RangeValues(-4, 4);
  RangeValues? _exposureOffsetRange;
  double _exposureStep = 0.0;
  double _currentExposureOffset = 0.0;

  double _ev100 = 0.0;

  CameraContainerBloc(
    this._meteringInteractor,
    MeteringCommunicationBloc communicationBloc,
  ) : super(
          communicationBloc,
          const CameraInitState(),
        ) {
    _observer = _WidgetsBindingObserver(_appLifecycleStateObserver);
    WidgetsBinding.instance.addObserver(_observer);

    on<RequestPermissionEvent>(_onRequestPermission);
    on<OpenAppSettingsEvent>(_onOpenAppSettings);
    on<InitializeEvent>(_onInitialize);
    on<ZoomChangedEvent>(_onZoomChanged);
    on<ExposureOffsetChangedEvent>(_onExposureOffsetChanged);
    on<ExposureOffsetResetEvent>(_onExposureOffsetResetEvent);

    add(const RequestPermissionEvent());
  }

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(_observer);
    unawaited(_cameraController?.dispose());
    communicationBloc.add(communication_event.MeteringEndedEvent(_ev100));
    return super.close();
  }

  @override
  void onCommunicationState(communication_states.SourceState communicationState) {
    if (communicationState is communication_states.MeasureState) {
      _takePhoto().then((ev100Raw) {
        if (ev100Raw != null) {
          _ev100 = ev100Raw + _meteringInteractor.cameraEvCalibration;
          communicationBloc.add(communication_event.MeteringEndedEvent(_ev100));
        }
      });
    }
  }

  Future<void> _onRequestPermission(_, Emitter emit) async {
    final hasPermission = await _meteringInteractor.requestPermission();
    if (!hasPermission) {
      emit(const CameraErrorState(CameraErrorType.permissionNotGranted));
    } else {
      add(const InitializeEvent());
    }
  }

  Future<void> _onOpenAppSettings(_, Emitter emit) async {
    _meteringInteractor.openAppSettings();
  }

  Future<void> _onInitialize(_, Emitter emit) async {
    emit(const CameraLoadingState());
    final hasPermission = await _meteringInteractor.checkCameraPermission();
    if (!hasPermission) {
      emit(const CameraErrorState(CameraErrorType.permissionNotGranted));
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        emit(const CameraErrorState(CameraErrorType.noCamerasDetected));
        return;
      }
      _cameraController = CameraController(
        cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.last,
        ),
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _cameraController!.setFlashMode(FlashMode.off);

      _zoomRange = await Future.wait<double>([
        _cameraController!.getMinZoomLevel(),
        _cameraController!.getMaxZoomLevel(),
      ]).then((levels) => RangeValues(levels[0], min(_maxZoom, levels[1])));
      _currentZoom = _zoomRange!.start;

      _exposureOffsetRange = await Future.wait<double>([
        _cameraController!.getMinExposureOffset(),
        _cameraController!.getMaxExposureOffset(),
      ]).then(
        (levels) => RangeValues(
          max(_exposureMaxRange.start, levels[0]),
          min(_exposureMaxRange.end, levels[1]),
        ),
      );
      await _cameraController!.getExposureOffsetStepSize().then((value) {
        _exposureStep = value == 0 ? 0.1 : value;
      });
      _currentExposureOffset = 0.0;

      emit(CameraInitializedState(_cameraController!));

      _emitActiveState(emit);
    } catch (e) {
      emit(const CameraErrorState(CameraErrorType.other));
    }
  }

  Future<void> _onZoomChanged(ZoomChangedEvent event, Emitter emit) async {
    _cameraController!.setZoomLevel(event.value);
    _currentZoom = event.value;
    _emitActiveState(emit);
  }

  Future<void> _onExposureOffsetChanged(ExposureOffsetChangedEvent event, Emitter emit) async {
    _cameraController!.setExposureOffset(event.value);
    _currentExposureOffset = event.value;
    _emitActiveState(emit);
  }

  Future<void> _onExposureOffsetResetEvent(ExposureOffsetResetEvent event, Emitter emit) async {
    _meteringInteractor.quickVibration();
    add(const ExposureOffsetChangedEvent(0));
  }

  void _emitActiveState(Emitter emit) {
    emit(CameraActiveState(
      zoomRange: _zoomRange!,
      currentZoom: _currentZoom,
      exposureOffsetRange: _exposureOffsetRange!,
      exposureOffsetStep: _exposureStep,
      currentExposureOffset: _currentExposureOffset,
    ));
  }

  Future<double?> _takePhoto() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _cameraController!.value.isTakingPicture) {
      return null;
    }

    try {
      final file = await _cameraController!.takePicture();
      final Uint8List bytes = await file.readAsBytes();
      Directory(file.path).deleteSync(recursive: true);

      final tags = await readExifFromBytes(bytes);
      final iso = double.parse("${tags["EXIF ISOSpeedRatings"]}");
      final apertureValueRatio = (tags["EXIF FNumber"]!.values as IfdRatios).ratios.first;
      final aperture = apertureValueRatio.numerator / apertureValueRatio.denominator;
      final speedValueRatio = (tags["EXIF ExposureTime"]!.values as IfdRatios).ratios.first;
      final speed = speedValueRatio.numerator / speedValueRatio.denominator;

      return log2(pow(aperture, 2)) - log2(speed) - log2(iso / 100);
    } on CameraException catch (e) {
      debugPrint('Error: ${e.code}\nError Message: ${e.description}');
      return null;
    }
  }

  Future<void> _appLifecycleStateObserver(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        add(const InitializeEvent());
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _cameraController?.dispose();
        _cameraController = null;
        break;
      default:
    }
  }
}

/// This is needed only because we cannot use `with` with mixins
class _WidgetsBindingObserver with WidgetsBindingObserver {
  final ValueChanged<AppLifecycleState> onLifecycleStateChanged;
  AppLifecycleState? _prevState;

  _WidgetsBindingObserver(this.onLifecycleStateChanged);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_prevState == AppLifecycleState.inactive && state == AppLifecycleState.resumed) {
      return;
    }
    _prevState = state;
    onLifecycleStateChanged(state);
  }
}
