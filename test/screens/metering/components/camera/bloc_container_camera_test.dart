import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/communication/event_communication_metering.dart' as communication_events;
import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart' as communication_states;
import 'package:lightmeter/screens/metering/components/camera_container/bloc_container_camera.dart';
import 'package:lightmeter/screens/metering/components/camera_container/event_container_camera.dart';
import 'package:lightmeter/screens/metering/components/camera_container/models/camera_error_type.dart';
import 'package:lightmeter/screens/metering/components/camera_container/state_container_camera.dart';
import 'package:mocktail/mocktail.dart';

class _MockMeteringInteractor extends Mock implements MeteringInteractor {}

class _MockMeteringCommunicationBloc
    extends MockBloc<communication_events.MeteringCommunicationEvent, communication_states.MeteringCommunicationState>
    implements MeteringCommunicationBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockMeteringInteractor meteringInteractor;
  late _MockMeteringCommunicationBloc communicationBloc;
  late CameraContainerBloc bloc;

  const cameraMethodChannel = MethodChannel('plugins.flutter.io/camera');
  const cameraIdMethodChannel = MethodChannel('flutter.io/cameraPlugin/camera1');
  const availableCameras = [
    {
      "name": "front",
      "lensFacing": "front",
      "sensorOrientation": 0,
    },
    {
      "name": "back",
      "lensFacing": "back",
      "sensorOrientation": 0,
    },
  ];
  const frontCameras = [
    {
      "name": "front",
      "lensFacing": "front",
      "sensorOrientation": 0,
    },
    {
      "name": "front2",
      "lensFacing": "front",
      "sensorOrientation": 0,
    },
  ];
  Future<Object?>? cameraMethodCallSuccessHandler(
    MethodCall methodCall, {
    List<Map<String, Object>> cameras = availableCameras,
  }) async {
    switch (methodCall.method) {
      case "availableCameras":
        return cameras;
      case "create":
        return {"cameraId": 1};
      case "initialize":
        await cameraIdMethodChannel.invokeMockMethod("initialized", {
          'cameraId': 1,
          'previewWidth': 2160.0,
          'previewHeight': 3840.0,
          'exposureMode': 'auto',
          'exposurePointSupported': true,
          'focusMode': 'auto',
          'focusPointSupported': true,
        });
        return {};
      case "setFlashMode":
        return null;
      case "getMinZoomLevel":
        return 0.67;
      case "getMaxZoomLevel":
        return 7.0;
      case "getMinExposureOffset":
        return -4.0;
      case "getMaxExposureOffset":
        return 4.0;
      case "getExposureOffsetStepSize":
        return 0.1666666;
      case "takePicture":
        return "";
      case "setExposureOffset":
        // ignore: avoid_dynamic_calls
        return methodCall.arguments["offset"];
      default:
        return null;
    }
  }

  final initializedStateSequence = [
    isA<CameraLoadingState>(),
    isA<CameraInitializedState>(),
    isA<CameraActiveState>()
        .having((state) => state.zoomRange, 'zoomRange', const RangeValues(1.0, 7.0))
        .having((state) => state.currentZoom, 'currentZoom', 1.0)
        .having(
          (state) => state.exposureOffsetRange,
          'exposureOffsetRange',
          const RangeValues(-4.0, 4.0),
        )
        .having((state) => state.exposureOffsetStep, 'exposureOffsetStep', 0.1666666)
        .having((state) => state.currentExposureOffset, 'currentExposureOffset', 0.0),
  ];

  setUpAll(() {
    meteringInteractor = _MockMeteringInteractor();
    communicationBloc = _MockMeteringCommunicationBloc();

    when(() => meteringInteractor.cameraEvCalibration).thenReturn(0.0);
    when(meteringInteractor.quickVibration).thenAnswer((_) async {});
  });

  setUp(() {
    bloc = CameraContainerBloc(
      meteringInteractor,
      communicationBloc,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(cameraMethodChannel, cameraMethodCallSuccessHandler);
  });

  tearDown(() {
    bloc.close();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(cameraMethodChannel, null);
  });

  group(
    '`RequestPermissionEvent`',
    () {
      blocTest<CameraContainerBloc, CameraContainerState>(
        'Request denied',
        build: () => bloc,
        setUp: () {
          when(() => meteringInteractor.requestCameraPermission()).thenAnswer((_) async => false);
        },
        act: (bloc) => bloc.add(const RequestPermissionEvent()),
        verify: (_) {
          verify(() => meteringInteractor.requestCameraPermission()).called(1);
        },
        expect: () => [
          isA<CameraErrorState>().having((state) => state.error, "error", CameraErrorType.permissionNotGranted),
        ],
      );

      blocTest<CameraContainerBloc, CameraContainerState>(
        'Request granted -> check denied',
        build: () => bloc,
        setUp: () {
          when(() => meteringInteractor.requestCameraPermission()).thenAnswer((_) async => true);
          when(() => meteringInteractor.checkCameraPermission()).thenAnswer((_) async => false);
        },
        act: (bloc) => bloc.add(const RequestPermissionEvent()),
        verify: (_) {
          verify(() => meteringInteractor.requestCameraPermission()).called(1);
          verify(() => meteringInteractor.checkCameraPermission()).called(1);
        },
        expect: () => [
          isA<CameraLoadingState>(),
          isA<CameraErrorState>().having((state) => state.error, "error", CameraErrorType.permissionNotGranted),
        ],
      );

      blocTest<CameraContainerBloc, CameraContainerState>(
        'Request granted -> check granted',
        build: () => bloc,
        setUp: () {
          when(() => meteringInteractor.requestCameraPermission()).thenAnswer((_) async => true);
          when(() => meteringInteractor.checkCameraPermission()).thenAnswer((_) async => true);
        },
        act: (bloc) => bloc.add(const RequestPermissionEvent()),
        verify: (_) {
          verify(() => meteringInteractor.requestCameraPermission()).called(1);
          verify(() => meteringInteractor.checkCameraPermission()).called(1);
        },
        expect: () => initializedStateSequence,
      );
    },
  );

  group(
    '`OpenAppSettingsEvent`',
    () {
      blocTest<CameraContainerBloc, CameraContainerState>(
        'App settings opened',
        setUp: () {
          when(() => meteringInteractor.openAppSettings()).thenAnswer((_) {});
        },
        build: () => bloc,
        act: (bloc) async {
          bloc.add(const OpenAppSettingsEvent());
        },
        verify: (_) {
          verify(() => meteringInteractor.openAppSettings()).called(1);
        },
        expect: () => [],
      );
    },
  );

  group(
    '`InitializeEvent`/`DeinitializeEvent`',
    () {
      blocTest<CameraContainerBloc, CameraContainerState>(
        'No cameras detected error',
        setUp: () {
          when(() => meteringInteractor.checkCameraPermission()).thenAnswer((_) async => true);
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
            cameraMethodChannel,
            (methodCall) async => cameraMethodCallSuccessHandler(methodCall, cameras: const []),
          );
        },
        tearDown: () {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(cameraMethodChannel, null);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(const InitializeEvent()),
        verify: (_) {
          verify(() => meteringInteractor.checkCameraPermission()).called(1);
        },
        expect: () => [
          isA<CameraLoadingState>(),
          isA<CameraErrorState>().having((state) => state.error, "error", CameraErrorType.noCamerasDetected),
        ],
      );

      blocTest<CameraContainerBloc, CameraContainerState>(
        'No back facing cameras available',
        setUp: () {
          when(() => meteringInteractor.checkCameraPermission()).thenAnswer((_) async => true);
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
            cameraMethodChannel,
            (methodCall) async => cameraMethodCallSuccessHandler(methodCall, cameras: frontCameras),
          );
        },
        tearDown: () {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(cameraMethodChannel, null);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(const InitializeEvent()),
        verify: (_) {
          verify(() => meteringInteractor.checkCameraPermission()).called(1);
        },
        expect: () => initializedStateSequence,
      );

      blocTest<CameraContainerBloc, CameraContainerState>(
        'Catch other initialization errors',
        setUp: () {
          when(() => meteringInteractor.checkCameraPermission()).thenAnswer((_) async => true);
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
            cameraMethodChannel,
            (methodCall) async {
              switch (methodCall.method) {
                case "availableCameras":
                  return availableCameras;
                default:
                  return null;
              }
            },
          );
        },
        tearDown: () {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(cameraMethodChannel, null);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(const InitializeEvent()),
        verify: (_) {
          verify(() => meteringInteractor.checkCameraPermission()).called(1);
        },
        expect: () => [
          isA<CameraLoadingState>(),
          isA<CameraErrorState>().having((state) => state.error, "error", CameraErrorType.other),
        ],
      );

      blocTest<CameraContainerBloc, CameraContainerState>(
        'appLifecycleStateObserver',
        setUp: () {
          when(() => meteringInteractor.checkCameraPermission()).thenAnswer((_) async => true);
        },
        build: () => bloc,
        act: (bloc) async {
          bloc.add(const InitializeEvent());
          await Future.delayed(Duration.zero);
          TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.detached);
          TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        },
        verify: (_) {
          verify(() => meteringInteractor.checkCameraPermission()).called(2);
        },
        expect: () => [
          ...initializedStateSequence,
          const CameraInitState(),
          ...initializedStateSequence,
        ],
      );

      blocTest<CameraContainerBloc, CameraContainerState>(
        'onCommunicationState',
        setUp: () {
          when(() => meteringInteractor.checkCameraPermission()).thenAnswer((_) async => true);
        },
        build: () => bloc,
        act: (bloc) async {
          bloc.add(const InitializeEvent());
          await Future.delayed(Duration.zero);
          bloc.onCommunicationState(const communication_states.SettingsOpenedState());
          await Future.delayed(Duration.zero);
          bloc.onCommunicationState(const communication_states.SettingsClosedState());
        },
        verify: (_) {
          verify(() => meteringInteractor.checkCameraPermission()).called(2);
        },
        expect: () => [
          ...initializedStateSequence,
          const CameraInitState(),
          ...initializedStateSequence,
        ],
      );
    },
  );

  group(
    '`_takePicture()`',
    () {
      blocTest<CameraContainerBloc, CameraContainerState>(
        'Returned ev100 == null',
        setUp: () {
          when(() => meteringInteractor.checkCameraPermission()).thenAnswer((_) async => true);
        },
        build: () => bloc,
        act: (bloc) async {
          bloc.add(const InitializeEvent());
          await Future.delayed(Duration.zero);
          bloc.onCommunicationState(const communication_states.MeasureState());
          bloc.onCommunicationState(const communication_states.MeasureState());
          bloc.onCommunicationState(const communication_states.MeasureState());
          bloc.onCommunicationState(const communication_states.MeasureState());
        },
        verify: (_) {
          verify(() => meteringInteractor.checkCameraPermission()).called(1);
          verifyNever(() => meteringInteractor.cameraEvCalibration);
        },
        expect: () => initializedStateSequence,
      );

      // TODO(vodemn): figure out how to mock `_file.readAsBytes()`
      // blocTest<CameraContainerBloc, CameraContainerState>(
      //   'Returned non-null ev100',
      //   setUp: () {
      //     when(() => meteringInteractor.checkCameraPermission()).thenAnswer((_) async => true);
      //     TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      //         .setMockMethodCallHandler(cameraMethodChannel, cameraMethodCallSuccessHandler);
      //   },
      //   tearDown: () {
      //     TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      //         .setMockMethodCallHandler(cameraMethodChannel, null);
      //   },
      //   build: () => bloc,
      //   act: (bloc) async {
      //     bloc.add(const InitializeEvent());
      //     await Future.delayed(Duration.zero);
      //     bloc.onCommunicationState(const communication_states.MeasureState());
      //   },
      //   verify: (_) {
      //     verify(() => meteringInteractor.checkCameraPermission()).called(1);
      //     verifyNever(() => meteringInteractor.cameraEvCalibration);
      //     verify(() {
      //       communicationBloc.add(const communication_events.MeteringEndedEvent(null));
      //     }).called(2);
      //   },
      //   expect: () => [
      //     ...initializedStateSequence,
      //   ],
      // );
    },
  );

  group(
    '`ZoomChangedEvent`',
    () {
      blocTest<CameraContainerBloc, CameraContainerState>(
        'Set zoom multiple times',
        setUp: () {
          when(() => meteringInteractor.checkCameraPermission()).thenAnswer((_) async => true);
        },
        build: () => bloc,
        act: (bloc) async {
          bloc.add(const InitializeEvent());
          await Future.delayed(Duration.zero);
          bloc.add(const ZoomChangedEvent(2.0));
          bloc.add(const ZoomChangedEvent(2.0));
          bloc.add(const ZoomChangedEvent(2.0));
          bloc.add(const ZoomChangedEvent(3.0));
        },
        verify: (_) {
          verify(() => meteringInteractor.checkCameraPermission()).called(1);
        },
        expect: () => [
          ...initializedStateSequence,
          isA<CameraActiveState>()
              .having((state) => state.zoomRange, 'zoomRange', const RangeValues(1.0, 7.0))
              .having((state) => state.currentZoom, 'currentZoom', 2.0)
              .having(
                (state) => state.exposureOffsetRange,
                'exposureOffsetRange',
                const RangeValues(-4.0, 4.0),
              )
              .having((state) => state.exposureOffsetStep, 'exposureOffsetStep', 0.1666666)
              .having((state) => state.currentExposureOffset, 'currentExposureOffset', 0.0),
          isA<CameraActiveState>()
              .having((state) => state.zoomRange, 'zoomRange', const RangeValues(1.0, 7.0))
              .having((state) => state.currentZoom, 'currentZoom', 3.0)
              .having(
                (state) => state.exposureOffsetRange,
                'exposureOffsetRange',
                const RangeValues(-4.0, 4.0),
              )
              .having((state) => state.exposureOffsetStep, 'exposureOffsetStep', 0.1666666)
              .having((state) => state.currentExposureOffset, 'currentExposureOffset', 0.0),
        ],
      );
    },
  );

  group(
    '`ExposureOffsetChangedEvent`/`ExposureOffsetResetEvent`',
    () {
      blocTest<CameraContainerBloc, CameraContainerState>(
        'Set exposure offset multiple times and reset',
        setUp: () {
          when(() => meteringInteractor.checkCameraPermission()).thenAnswer((_) async => true);
        },
        build: () => bloc,
        act: (bloc) async {
          bloc.add(const InitializeEvent());
          await Future.delayed(Duration.zero);
          bloc.add(const ExposureOffsetChangedEvent(2.0));
          bloc.add(const ExposureOffsetChangedEvent(2.0));
          bloc.add(const ExposureOffsetChangedEvent(2.0));
          bloc.add(const ExposureOffsetChangedEvent(3.0));
          bloc.add(const ExposureOffsetResetEvent());
        },
        verify: (_) {
          verify(() => meteringInteractor.checkCameraPermission()).called(1);
        },
        expect: () => [
          ...initializedStateSequence,
          isA<CameraActiveState>()
              .having((state) => state.zoomRange, 'zoomRange', const RangeValues(1.0, 7.0))
              .having((state) => state.currentZoom, 'currentZoom', 1.0)
              .having(
                (state) => state.exposureOffsetRange,
                'exposureOffsetRange',
                const RangeValues(-4.0, 4.0),
              )
              .having((state) => state.exposureOffsetStep, 'exposureOffsetStep', 0.1666666)
              .having((state) => state.currentExposureOffset, 'currentExposureOffset', 2.0),
          isA<CameraActiveState>()
              .having((state) => state.zoomRange, 'zoomRange', const RangeValues(1.0, 7.0))
              .having((state) => state.currentZoom, 'currentZoom', 1.0)
              .having(
                (state) => state.exposureOffsetRange,
                'exposureOffsetRange',
                const RangeValues(-4.0, 4.0),
              )
              .having((state) => state.exposureOffsetStep, 'exposureOffsetStep', 0.1666666)
              .having((state) => state.currentExposureOffset, 'currentExposureOffset', 3.0),
          isA<CameraActiveState>()
              .having((state) => state.zoomRange, 'zoomRange', const RangeValues(1.0, 7.0))
              .having((state) => state.currentZoom, 'currentZoom', 1.0)
              .having(
                (state) => state.exposureOffsetRange,
                'exposureOffsetRange',
                const RangeValues(-4.0, 4.0),
              )
              .having((state) => state.exposureOffsetStep, 'exposureOffsetStep', 0.1666666)
              .having((state) => state.currentExposureOffset, 'currentExposureOffset', 0.0),
        ],
      );
    },
  );

  group(
    '`ExposureSpotChangedEvent`',
    () {
      blocTest<CameraContainerBloc, CameraContainerState>(
        'Set exposure spot multiple times',
        setUp: () {
          when(() => meteringInteractor.checkCameraPermission()).thenAnswer((_) async => true);
        },
        build: () => bloc,
        act: (bloc) async {
          bloc.add(const InitializeEvent());
          await Future.delayed(Duration.zero);
          bloc.add(const ExposureSpotChangedEvent(Offset(0.1, 0.1)));
          bloc.add(const ExposureSpotChangedEvent(Offset(1.0, 0.5)));
        },
        verify: (_) {
          verify(() => meteringInteractor.checkCameraPermission()).called(1);
        },
        expect: () => [...initializedStateSequence],
      );
    },
  );
}

extension _MethodChannelMock on MethodChannel {
  Future<void> invokeMockMethod(String method, dynamic arguments) async {
    final data = const StandardMethodCodec().encodeMethodCall(MethodCall(method, arguments));
    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
      name,
      data,
      (ByteData? data) {},
    );
  }
}
