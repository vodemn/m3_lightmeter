import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:exif/exif.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/communication/event_communication_metering.dart' as communication_event;
import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart' as communication_states;
import 'package:lightmeter/utils/log_2.dart';

import 'event_camera.dart';
import 'state_camera.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final MeteringCommunicationBloc _communicationBloc;
  late final StreamSubscription<communication_states.MeteringCommunicationState> _communicationSubscription;

  late final _WidgetsBindingObserver _observer;
  CameraController? _cameraController;
  CameraController? get cameraController => _cameraController;

  CameraBloc(this._communicationBloc) : super(const CameraInitState()) {
    _communicationSubscription = _communicationBloc.stream.listen(_onCommunicationState);

    _observer = _WidgetsBindingObserver(_appLifecycleStateObserver);
    WidgetsBinding.instance.addObserver(_observer);

    on<InitializeEvent>(_onInitialized);

    add(const InitializeEvent());
  }

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(_observer);
    _cameraController?.dispose();
    await _communicationSubscription.cancel();
    super.close();
  }

  void _onCommunicationState(communication_states.MeteringCommunicationState communicationState) {
    if (communicationState is communication_states.MeasureState) {
      _takePhoto().then((ev100) {
        if (ev100 != null) {
          _communicationBloc.add(communication_event.MeasuredEvent(ev100));
        }
      });
    }
  }

  Future<void> _onInitialized(_, Emitter emit) async {
    emit(const CameraLoadingState());
    try {
      final cameras = await availableCameras();
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
      emit(CameraReadyState(_cameraController!));
      _takePhoto().then((ev100) {
        if (ev100 != null) {
          _communicationBloc.add(communication_event.MeasuredEvent(ev100));
        }
      });
    } catch (e) {
      emit(const CameraErrorState());
    }
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
      case AppLifecycleState.inactive:
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

  _WidgetsBindingObserver(this.onLifecycleStateChanged);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    onLifecycleStateChanged(state);
  }
}
