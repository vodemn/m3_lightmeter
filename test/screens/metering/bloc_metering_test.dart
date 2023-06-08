import 'package:bloc_test/bloc_test.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/screens/metering/bloc_metering.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/communication/event_communication_metering.dart'
    as communication_events;
import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart'
    as communication_states;
import 'package:lightmeter/screens/metering/event_metering.dart';
import 'package:lightmeter/screens/metering/state_metering.dart';
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
  late EquipmentProfileData equipmentProfileData;
  late MeteringBloc bloc;
  const iso100 = IsoValue(100, StopType.full);

  setUpAll(() {
    communicationBloc = _MockMeteringCommunicationBloc();
    meteringInteractor = _MockMeteringInteractor();
    equipmentProfileData = const EquipmentProfileData(
      id: '0',
      name: 'Test equipment',
      apertureValues: ApertureValue.values,
      ndValues: NdValue.values,
      shutterSpeedValues: ShutterSpeedValue.values,
      isoValues: IsoValue.values,
    );

    when<IsoValue>(() => meteringInteractor.iso).thenReturn(iso100);
    when<NdValue>(() => meteringInteractor.ndFilter).thenReturn(NdValue.values.first);
    when<Film>(() => meteringInteractor.film).thenReturn(Film.values.first);
    when(meteringInteractor.quickVibration).thenAnswer((_) async {});
    when(meteringInteractor.responseVibration).thenAnswer((_) async {});
    when(meteringInteractor.errorVibration).thenAnswer((_) async {});
  });

  setUp(() {
    bloc = MeteringBloc(
      communicationBloc,
      meteringInteractor,
      equipmentProfileData,
      StopType.third,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('Initial state test', () {
    test('Initial state', () {
      expect(
        bloc.state,
        isA<MeteringDataState>()
            .having((state) => state.ev, 'ev', null)
            .having((state) => state.film, 'film', bloc.film)
            .having((state) => state.iso, 'iso', bloc.iso)
            .having((state) => state.nd, 'nd', bloc.nd)
            .having((state) => state.exposurePairs, 'exposurePairs', const []),
      );
    });
  });

  group(
    '`MeasureEvent` tests',
    () {
      blocTest<MeteringBloc, MeteringState>(
        '`MeasureEvent` -> success',
        build: () => bloc,
        act: (bloc) async {
          bloc.add(const MeasureEvent());
          bloc.onCommunicationState(const communication_states.MeteringEndedState(2));
        },
        verify: (_) {
          verify(() => meteringInteractor.quickVibration()).called(1);
          verify(() => communicationBloc.add(const communication_events.MeasureEvent())).called(1);
          verify(() => meteringInteractor.responseVibration()).called(1);
        },
        expect: () => [
          isA<LoadingState>(),
          isA<MeteringDataState>()
              .having((state) => state.continuousMetering, 'continuousMetering', false)
              .having((state) => state.ev, 'ev', 2),
        ],
      );

      blocTest<MeteringBloc, MeteringState>(
        '`MeasureEvent` -> error',
        build: () => bloc,
        act: (bloc) async {
          bloc.add(const MeasureEvent());
          bloc.onCommunicationState(const communication_states.MeteringEndedState(null));
        },
        verify: (_) {
          verify(() => meteringInteractor.quickVibration()).called(1);
          verify(() => communicationBloc.add(const communication_events.MeasureEvent())).called(1);
          verify(() => meteringInteractor.errorVibration()).called(1);
        },
        expect: () => [
          isA<LoadingState>(),
          isA<MeteringDataState>()
              .having((state) => state.continuousMetering, 'continuousMetering', false)
              .having((_) => bloc.ev100, 'ev100', null)
              .having((state) => state.ev, 'ev', null),
        ],
      );

      blocTest<MeteringBloc, MeteringState>(
        '`MeasureEvent` -> continuous metering',
        build: () => bloc,
        act: (bloc) async {
          // delays here simulate light sensor behaviour
          // when sensor does not fire new LUX events when value is not changed
          bloc.add(const MeasureEvent());
          bloc.onCommunicationState(const communication_states.MeteringInProgressState(null));
          await Future.delayed(const Duration(seconds: 1));
          bloc.onCommunicationState(const communication_states.MeteringInProgressState(2));
          bloc.onCommunicationState(const communication_states.MeteringInProgressState(5.5));
          await Future.delayed(const Duration(seconds: 2));
          bloc.onCommunicationState(const communication_states.MeteringInProgressState(null));
          bloc.onCommunicationState(const communication_states.MeteringInProgressState(4));
          bloc.add(const MeasureEvent());
          bloc.onCommunicationState(const communication_states.MeteringEndedState(4));
        },
        verify: (_) {
          verify(() => meteringInteractor.quickVibration()).called(2);
          verify(() => communicationBloc.add(const communication_events.MeasureEvent())).called(2);
          verify(() => meteringInteractor.responseVibration()).called(4);
          verify(() => meteringInteractor.errorVibration()).called(2);
        },
        expect: () => [
          isA<LoadingState>(),
          isA<MeteringDataState>()
              .having((state) => state.continuousMetering, 'continuousMetering', true)
              .having((state) => state.ev, 'ev', null),
          isA<MeteringDataState>()
              .having((state) => state.continuousMetering, 'continuousMetering', true)
              .having((state) => state.ev, 'ev', 2),
          isA<MeteringDataState>()
              .having((state) => state.continuousMetering, 'continuousMetering', true)
              .having((state) => state.ev, 'ev', 5.5),
          isA<MeteringDataState>()
              .having((state) => state.continuousMetering, 'continuousMetering', true)
              .having((state) => state.ev, 'ev', null),
          isA<MeteringDataState>()
              .having((state) => state.continuousMetering, 'continuousMetering', true)
              .having((state) => state.ev, 'ev', 4),
          isA<LoadingState>(),
          isA<MeteringDataState>()
              .having((state) => state.continuousMetering, 'continuousMetering', false)
              .having((state) => state.ev, 'ev', 4),
        ],
      );
    },
    timeout: const Timeout(Duration(seconds: 4)),
  );

  group(
    '`IsoChangedEvent` tests',
    () {
      //
    },
  );

  group(
    '`NdChangedEvent` tests',
    () {
      //
    },
  );

  group(
    '`FilmChangedEvent` tests',
    () {
      //
    },
  );

  group(
    '`StopTypeChangedEvent` tests',
    () {
      //
    },
  );

  group(
    '`EquipmentProfileChangedEvent` tests',
    () {
      //
    },
  );
}
