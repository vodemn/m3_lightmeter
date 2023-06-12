import 'package:bloc_test/bloc_test.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/communication/event_communication_metering.dart'
    as communication_events;
import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart'
    as communication_states;
import 'package:lightmeter/screens/metering/components/light_sensor_container/bloc_container_light_sensor.dart';
import 'package:lightmeter/screens/metering/components/light_sensor_container/state_container_light_sensor.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockMeteringCommunicationBloc extends MockBloc<
    communication_events.MeteringCommunicationEvent,
    communication_states.MeteringCommunicationState> implements MeteringCommunicationBloc {}

class _MockMeteringInteractor extends Mock implements MeteringInteractor {}

void main() {
  late _MockMeteringCommunicationBloc communicationBloc;
  late _MockMeteringInteractor meteringInteractor;
  late LightSensorContainerBloc bloc;

  setUpAll(() {
    communicationBloc = _MockMeteringCommunicationBloc();
    meteringInteractor = _MockMeteringInteractor();
  });

  setUp(() {
    bloc = LightSensorContainerBloc(
      meteringInteractor,
      communicationBloc,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group(
    '`LuxMeteringEvent` tests',
    () {
      const List<int> luxIterable = [1, 2, 2, 2, 3];
      final List<double> resultList = luxIterable.map((lux) => log2(lux / 2.5)).toList();
      blocTest<LightSensorContainerBloc, LightSensorContainerState>(
        'Turn measuring on/off',
        build: () => bloc,
        setUp: () {
          when(() => meteringInteractor.luxStream())
              .thenAnswer((_) => Stream.fromIterable(luxIterable));
          when(() => meteringInteractor.lightSensorEvCalibration).thenReturn(0.0);
        },
        act: (bloc) async {
          bloc.onCommunicationState(const communication_states.MeasureState());
          await Future.delayed(Duration.zero);
          bloc.onCommunicationState(const communication_states.MeasureState());
        },
        verify: (_) {
          verify(() => meteringInteractor.luxStream().listen((_) {})).called(1);
          verify(() => meteringInteractor.lightSensorEvCalibration).called(5);
          verify(() {
            communicationBloc.add(communication_events.MeteringInProgressEvent(resultList.first));
          }).called(1);
          verify(() {
            communicationBloc.add(communication_events.MeteringInProgressEvent(resultList[1]));
          }).called(3);
          verify(() {
            communicationBloc.add(communication_events.MeteringInProgressEvent(resultList.last));
          }).called(1);
          verify(() {
            communicationBloc.add(communication_events.MeteringEndedEvent(resultList.last));
          }).called(2); // +1 from dispose
        },
        expect: () => resultList.map(
          (e) => isA<LightSensorContainerState>().having((state) => state.ev100, 'ev100', e),
        ),
      );
    },
  );
}
