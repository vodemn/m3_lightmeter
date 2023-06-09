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
  late MeteringBloc bloc;
  const iso100 = IsoValue(100, StopType.full);

  setUpAll(() {
    communicationBloc = _MockMeteringCommunicationBloc();
    meteringInteractor = _MockMeteringInteractor();

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
    );
  });

  tearDown(() {
    bloc.close();
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
              .having((state) => state.isMetering, 'isMetering', false)
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
              .having((state) => state.isMetering, 'isMetering', false)
              .having((state) => state.ev100, 'ev100', null)
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
              .having((state) => state.isMetering, 'isMetering', true)
              .having((state) => state.ev, 'ev', null),
          isA<MeteringDataState>()
              .having((state) => state.isMetering, 'isMetering', true)
              .having((state) => state.ev, 'ev', 2),
          isA<MeteringDataState>()
              .having((state) => state.isMetering, 'isMetering', true)
              .having((state) => state.ev, 'ev', 5.5),
          isA<MeteringDataState>()
              .having((state) => state.isMetering, 'isMetering', true)
              .having((state) => state.ev, 'ev', null),
          isA<MeteringDataState>()
              .having((state) => state.isMetering, 'isMetering', true)
              .having((state) => state.ev, 'ev', 4),
          isA<LoadingState>(),
          isA<MeteringDataState>()
              .having((state) => state.isMetering, 'isMetering', false)
              .having((state) => state.ev, 'ev', 4),
        ],
      );
    },
    timeout: const Timeout(Duration(seconds: 4)),
  );

  group(
    '`IsoChangedEvent` tests',
    () {
      blocTest<MeteringBloc, MeteringState>(
        'Pick different ISO (ev100 != null)',
        build: () => bloc,
        seed: () => MeteringDataState(
          ev100: 1.0,
          film: Film.values[1],
          iso: const IsoValue(100, StopType.full),
          nd: NdValue.values.first,
          isMetering: false,
        ),
        act: (bloc) async {
          bloc.add(const IsoChangedEvent(IsoValue(200, StopType.full)));
        },
        verify: (_) {
          verify(() => meteringInteractor.film = Film.values.first).called(1);
          verify(() => meteringInteractor.iso = const IsoValue(200, StopType.full)).called(1);
        },
        expect: () => [
          isA<MeteringDataState>()
              .having((state) => state.ev100, 'ev100', 1.0)
              .having((state) => state.ev, 'ev', 2.0)
              .having((state) => state.film, 'film', Film.values.first)
              .having((state) => state.iso, 'iso', const IsoValue(200, StopType.full))
              .having((state) => state.nd, 'nd', NdValue.values.first)
              .having((state) => state.isMetering, 'isMetering', false),
        ],
      );

      blocTest<MeteringBloc, MeteringState>(
        'Pick different ISO (ev100 = null)',
        build: () => bloc,
        seed: () => MeteringDataState(
          ev100: null,
          film: Film.values[1],
          iso: const IsoValue(100, StopType.full),
          nd: NdValue.values.first,
          isMetering: false,
        ),
        act: (bloc) async {
          bloc.add(const IsoChangedEvent(IsoValue(200, StopType.full)));
        },
        verify: (_) {
          verify(() => meteringInteractor.film = Film.values.first).called(1);
          verify(() => meteringInteractor.iso = const IsoValue(200, StopType.full)).called(1);
        },
        expect: () => [
          isA<MeteringDataState>()
              .having((state) => state.ev100, 'ev100', null)
              .having((state) => state.ev, 'ev', null)
              .having((state) => state.film, 'film', Film.values.first)
              .having((state) => state.iso, 'iso', const IsoValue(200, StopType.full))
              .having((state) => state.nd, 'nd', NdValue.values.first)
              .having((state) => state.isMetering, 'isMetering', false),
        ],
      );

      blocTest<MeteringBloc, MeteringState>(
        'Pick same ISO',
        build: () => bloc,
        seed: () => MeteringDataState(
          ev100: 1.0,
          film: Film.values[1],
          iso: const IsoValue(100, StopType.full),
          nd: NdValue.values.first,
          isMetering: false,
        ),
        act: (bloc) async {
          bloc.add(const IsoChangedEvent(IsoValue(100, StopType.full)));
        },
        verify: (_) {
          verify(() => meteringInteractor.film = Film.values.first).called(1);
          verifyNever(() => meteringInteractor.iso = const IsoValue(100, StopType.full));
        },
        expect: () => [],
      );

      blocTest<MeteringBloc, MeteringState>(
        'Pick different ISO & measure',
        build: () => bloc,
        seed: () => MeteringDataState(
          ev100: 1.0,
          film: Film.values[1],
          iso: const IsoValue(100, StopType.full),
          nd: NdValue.values.first,
          isMetering: false,
        ),
        act: (bloc) async {
          bloc.add(const IsoChangedEvent(IsoValue(200, StopType.full)));
          bloc.add(const MeasureEvent());
          bloc.onCommunicationState(const communication_states.MeteringEndedState(2));
        },
        verify: (_) {
          verify(() => meteringInteractor.film = Film.values.first).called(1);
          verify(() => meteringInteractor.iso = const IsoValue(200, StopType.full)).called(1);
        },
        expect: () => [
          isA<MeteringDataState>()
              .having((state) => state.ev100, 'ev100', 1.0)
              .having((state) => state.ev, 'ev', 2.0)
              .having((state) => state.film, 'film', Film.values.first)
              .having((state) => state.iso, 'iso', const IsoValue(200, StopType.full))
              .having((state) => state.nd, 'nd', NdValue.values.first)
              .having((state) => state.isMetering, 'isMetering', false),
          isA<LoadingState>(),
          isA<MeteringDataState>()
              .having((state) => state.ev100, 'ev100', 2.0)
              .having((state) => state.ev, 'ev', 3.0)
              .having((state) => state.film, 'film', Film.values.first)
              .having((state) => state.iso, 'iso', const IsoValue(200, StopType.full))
              .having((state) => state.nd, 'nd', NdValue.values.first)
              .having((state) => state.isMetering, 'isMetering', false),
        ],
      );
    },
  );

  group(
    '`NdChangedEvent` tests',
    () {
      blocTest<MeteringBloc, MeteringState>(
        '`NdChangedEvent` -> success',
        build: () => bloc,
        seed: () => MeteringDataState(
          ev100: 1.0,
          film: Film.values[1],
          iso: const IsoValue(100, StopType.full),
          nd: NdValue.values.first,
          isMetering: false,
        ),
        act: (bloc) async {
          bloc.add(const NdChangedEvent(NdValue(2)));
        },
        verify: (_) {
          verify(() => meteringInteractor.film = Film.values.first).called(1);
          verify(() => meteringInteractor.ndFilter = const NdValue(2)).called(1);
        },
        expect: () => [
          isA<MeteringDataState>()
              .having((state) => state.ev100, 'ev100', 1.0)
              .having((state) => state.ev, 'ev', 2.0)
              .having((state) => state.iso, 'iso', const IsoValue(200, StopType.full))
              .having((state) => state.isMetering, 'isMetering', false),
        ],
      );
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
