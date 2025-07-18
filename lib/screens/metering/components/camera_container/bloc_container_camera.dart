import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/analytics/analytics.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/communication/event_communication_metering.dart' as communication_event;
import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart' as communication_states;
import 'package:lightmeter/screens/metering/components/camera_container/event_container_camera.dart';
import 'package:lightmeter/screens/metering/components/camera_container/models/camera_error_type.dart';
import 'package:lightmeter/screens/metering/components/camera_container/state_container_camera.dart';
import 'package:lightmeter/screens/metering/components/shared/ev_source_base/bloc_base_ev_source.dart';
import 'package:lightmeter/utils/exif_utils.dart';

part 'mock_bloc_container_camera.part.dart';

class CameraContainerBloc extends EvSourceBlocBase<CameraContainerEvent, CameraContainerState> {
  final MeteringInteractor _meteringInteractor;
  final LightmeterAnalytics _analytics;
  late final _WidgetsBindingObserver _observer;

  CameraDescription? _camera;
  CameraController? _cameraController;

  static const zoomMaxRange = RangeValues(1, 7);
  RangeValues? _zoomRange;
  double _currentZoom = 1.0;

  static const exposureMaxRange = RangeValues(-4, 4);
  RangeValues? _exposureOffsetRange;
  double _exposureStep = 0.1;
  double _currentExposureOffset = 0.0;

  double? _ev100 = 0.0;

  bool _settingsOpened = false;

  CameraContainerBloc(
    this._meteringInteractor,
    MeteringCommunicationBloc communicationBloc,
    this._analytics,
  ) : super(
          communicationBloc,
          const CameraInitState(),
        ) {
    _observer = _WidgetsBindingObserver(_appLifecycleStateObserver);
    WidgetsBinding.instance.addObserver(_observer);

    on<RequestPermissionEvent>(_onRequestPermission);
    on<OpenAppSettingsEvent>(_onOpenAppSettings);
    on<InitializeEvent>(_onInitialize);
    on<DeinitializeEvent>(_onDeinitialize);
    on<ZoomChangedEvent>(_onZoomChanged);
    on<ExposureOffsetChangedEvent>(_onExposureOffsetChanged);
    on<ExposureOffsetResetEvent>(_onExposureOffsetResetEvent);
    on<ExposureSpotChangedEvent>(_onExposureSpotChangedEvent);
  }

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(_observer);
    unawaited(_cameraController?.dispose().then((_) => _cameraController = null));
    communicationBloc.add(communication_event.MeteringEndedEvent(_ev100));
    return super.close();
  }

  @override
  void onCommunicationState(communication_states.SourceState communicationState) {
    switch (communicationState) {
      case communication_states.MeasureState():
        if (_canTakePhoto) {
          _takePhoto().then((photo) {
            if (photo != null) {
              _ev100 = photo.ev + _meteringInteractor.cameraEvCalibration;
              communicationBloc.add(communication_event.MeteringEndedEvent(_ev100, photoPath: photo.path));
            } else {
              _ev100 = null;
              communicationBloc.add(const communication_event.MeteringEndedEvent(null));
            }
          });
        }
      case final communication_states.EquipmentProfileChangedState communicationState:
        if (state is CameraActiveState) {
          add(ZoomChangedEvent(communicationState.profile.lensZoom));
          add(ExposureOffsetChangedEvent(communicationState.profile.exposureOffset));
        } else {
          _currentZoom = communicationState.profile.lensZoom;
          _currentExposureOffset = communicationState.profile.exposureOffset;
        }
      case communication_states.SettingsOpenedState():
        _settingsOpened = true;
        add(const DeinitializeEvent());
      case communication_states.SettingsClosedState():
        _settingsOpened = false;
        add(const InitializeEvent());
    }
  }

  Future<void> _onRequestPermission(_, Emitter emit) async {
    final hasPermission = await _meteringInteractor.requestCameraPermission();
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
      if (_camera == null) {
        final cameras = await availableCameras();
        if (cameras.isEmpty) {
          emit(const CameraErrorState(CameraErrorType.noCamerasDetected));
          return;
        } else {
          _camera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
            orElse: () => cameras.last,
          );
        }
      }

      final cameraController = CameraController(
        _camera!,
        ResolutionPreset.low,
        enableAudio: false,
      );
      await cameraController.initialize();
      await cameraController.setFlashMode(FlashMode.off);
      await cameraController.lockCaptureOrientation(DeviceOrientation.portraitUp);

      if (_exposureOffsetRange == null) {
        await Future.wait<double>([
          cameraController.getMinExposureOffset(),
          cameraController.getMaxExposureOffset(),
          cameraController.getExposureOffsetStepSize(),
        ]).then((value) {
          _exposureOffsetRange = RangeValues(
            math.max(exposureMaxRange.start, value[0]),
            math.min(exposureMaxRange.end, value[1]),
          );
          _currentExposureOffset = 0.0;
          _exposureStep = value[2] == 0 ? 0.1 : value[2];
        });
      }

      if (_zoomRange == null) {
        await Future.wait<double>([
          cameraController.getMinZoomLevel(),
          cameraController.getMaxZoomLevel(),
        ]).then((value) {
          _zoomRange = RangeValues(
            math.max(1.0, value[0]),
            math.min(zoomMaxRange.end, value[1]),
          );
          if (_currentZoom < _zoomRange!.start || _currentZoom > _zoomRange!.end) {
            _currentZoom = _zoomRange!.start;
          }
        });
      }

      /// For app startup initialization this effectively isn't executed.
      await Future.wait<void>([
        if (_currentZoom != 1.0) cameraController.setZoomLevel(_currentZoom),
        if (_currentExposureOffset != 0.0) cameraController.setExposureOffset(_currentExposureOffset),
      ]);

      _cameraController = cameraController;
      emit(CameraInitializedState(cameraController));
      _emitActiveState(emit);
    } catch (e, stackTrace) {
      _analytics.logCrash(e, stackTrace);
      emit(const CameraErrorState(CameraErrorType.other));
    }
  }

  Future<void> _onDeinitialize(DeinitializeEvent _, Emitter emit) async {
    emit(const CameraInitState());
    communicationBloc.add(communication_event.MeteringEndedEvent(_ev100));
    await _cameraController?.dispose().then((_) => _cameraController = null);
  }

  Future<void> _onZoomChanged(ZoomChangedEvent event, Emitter emit) async {
    if (_cameraController != null && _zoomRange != null) {
      final double zoom = event.value.clamp(_zoomRange!.start, _zoomRange!.end);
      _cameraController!.setZoomLevel(zoom);
      _currentZoom = zoom;
      _emitActiveState(emit);
    }
  }

  Future<void> _onExposureOffsetChanged(ExposureOffsetChangedEvent event, Emitter emit) async {
    if (_cameraController != null) {
      _cameraController!.setExposureOffset(event.value);
      _currentExposureOffset = event.value;
      _emitActiveState(emit);
    }
  }

  Future<void> _onExposureOffsetResetEvent(ExposureOffsetResetEvent event, Emitter emit) async {
    _meteringInteractor.quickVibration();
    add(const ExposureOffsetChangedEvent(0));
  }

  Future<void> _onExposureSpotChangedEvent(ExposureSpotChangedEvent event, Emitter emit) async {
    if (_cameraController != null) {
      _cameraController!.setExposurePoint(event.offset);
      _cameraController!.setFocusPoint(event.offset);
    }
  }

  void _emitActiveState(Emitter emit) {
    emit(
      CameraActiveState(
        zoomRange: _zoomRange!,
        currentZoom: _currentZoom,
        exposureOffsetRange: _exposureOffsetRange!,
        exposureOffsetStep: _exposureStep,
        currentExposureOffset: _currentExposureOffset,
      ),
    );
  }

  bool get _canTakePhoto =>
      PlatformConfig.cameraStubImage.isNotEmpty ||
      !(_cameraController == null ||
          !_cameraController!.value.isInitialized ||
          _cameraController!.value.isTakingPicture);

  Future<({double ev, String path})?> _takePhoto() async {
    try {
      final file = await _cameraController!.takePicture();
      final bytes = await file.readAsBytes();
      final tags = await readExifFromBytes(bytes);
      return (ev: evFromTags(tags), path: file.path);
    } catch (e, stackTrace) {
      _analytics.logCrash(e, stackTrace);
      return null;
    }
  }

  Future<void> _appLifecycleStateObserver(AppLifecycleState state) async {
    if (!_settingsOpened) {
      switch (state) {
        case AppLifecycleState.resumed:
          add(const InitializeEvent());
        case AppLifecycleState.paused:
        case AppLifecycleState.detached:
          add(const DeinitializeEvent());
        default:
      }
    }
  }
}

/// This is needed only because we cannot use `with` with mixins
class _WidgetsBindingObserver with WidgetsBindingObserver {
  final ValueChanged<AppLifecycleState> onLifecycleStateChanged;
  AppLifecycleState? _prevState;

  _WidgetsBindingObserver(this.onLifecycleStateChanged);

  /// Revoking camera permissions results in app being killed both on Android and iOS
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      return;
    }
    if (_prevState != state) {
      _prevState = state;
      onLifecycleStateChanged(state);
    }
  }
}
