part of 'bloc_container_camera.dart';

class MockCameraContainerBloc extends CameraContainerBloc {
  MockCameraContainerBloc(
    super._meteringInteractor,
    super.communicationBloc,
    super._analytics,
  );

  @override
  Future<void> _onRequestPermission(_, Emitter emit) async {
    add(const InitializeEvent());
  }

  @override
  Future<void> _onOpenAppSettings(_, Emitter emit) async {
    _meteringInteractor.openAppSettings();
  }

  @override
  Future<void> _onInitialize(_, Emitter emit) async {
    emit(const CameraLoadingState());
    try {
      _cameraController = CameraController(
        const CameraDescription(name: '0', lensDirection: CameraLensDirection.back, sensorOrientation: 0),
        ResolutionPreset.low,
        enableAudio: false,
      );

      _zoomRange = const RangeValues(1, 6);
      _currentZoom = _zoomRange!.start;

      _exposureOffsetRange = const RangeValues(-4, 4);
      _exposureStep = 0.1;
      _currentExposureOffset = 0.0;

      emit(CameraInitializedState(_cameraController!));

      _emitActiveState(emit);
    } catch (e) {
      emit(const CameraErrorState(CameraErrorType.other));
    }
  }

  @override
  Future<void> _onZoomChanged(ZoomChangedEvent event, Emitter emit) async {
    if (event.value >= _zoomRange!.start && event.value <= _zoomRange!.end) {
      _currentZoom = event.value;
      _emitActiveState(emit);
    }
  }

  @override
  Future<void> _onExposureOffsetChanged(ExposureOffsetChangedEvent event, Emitter emit) async {
    _currentExposureOffset = event.value;
    _emitActiveState(emit);
  }

  @override
  Future<void> _onExposureOffsetResetEvent(ExposureOffsetResetEvent event, Emitter emit) async {
    _meteringInteractor.quickVibration();
    add(const ExposureOffsetChangedEvent(0));
  }

  @override
  Future<void> _onExposureSpotChangedEvent(ExposureSpotChangedEvent event, Emitter emit) async {}

  @override
  bool get _canTakePhoto => PlatformConfig.cameraStubImage.isNotEmpty;

  @override
  Future<double?> _takePhoto() async {
    try {
      final bytes = (await rootBundle.load(PlatformConfig.cameraStubImage)).buffer.asUint8List();
      return await evFromImage(bytes);
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
      return null;
    }
  }
}
