import 'package:bloc_test/bloc_test.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/res/dimens.dart';
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
  double initEV = 0.0;

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

  group('MeteringBloc test:', () {
    test('Initial state', () {
      expect(
        bloc.state,
        isA<MeteringDataState>()
            .having((state) => state.ev, 'ev', null)
            .having((state) => state.film, 'film', bloc.film)
            .having((state) => state.iso, 'iso', bloc.iso)
            .having((state) => state.nd, 'nd', bloc.nd)
            .having((state) => state.exposurePairs, 'exposurePairs', const []).having(
          (state) => state.continuousMetering,
          'continuousMetering',
          bloc.isMeteringInProgress,
        ),
      );
    });

    blocTest<MeteringBloc, MeteringState>(
      'Measured',
      build: () => bloc,
      act: (bloc) => bloc.add(const MeasuredEvent(2)),
      verify: (_) {
        verify(() => meteringInteractor.responseVibration()).called(1);
      },
      expect: () => [
        isA<MeteringDataState>()
            .having((_) => bloc.ev100, 'ev100', 2)
            .having((state) => state.ev, 'ev', 2)
            .having((state) => state.film, 'film', Film.values.first)
            .having((state) => state.iso, 'iso', iso100)
            .having((state) => state.nd, 'nd', NdValue.values.first),
      ],
    );

    blocTest<MeteringBloc, MeteringState>(
      'Measured',
      build: () => bloc,
      setUp: () {
        when<IsoValue>(() => meteringInteractor.iso).thenReturn(iso100);
      },
      act: (bloc) {
        bloc.add(const MeasuredEvent(3));
        bloc.add(const MeasuredEvent(7));
        bloc.add(const MeasuredEvent(2));
      },
      verify: (_) {
        //verify(() => meteringInteractor.responseVibration()).called(1);
      },
      expect: () => [
        isA<MeteringDataState>()
            .having((_) => bloc.ev100, 'ev100', 3)
            .having((_) => bloc.iso, 'blocIso', iso100)
            .having((state) => state.ev, 'ev', 4)
            .having((state) => state.film, 'film', Film.values.first)
            .having((state) => state.iso, 'iso', iso100)
            .having((state) => state.nd, 'nd', NdValue.values.first),
        isA<MeteringDataState>()
            .having((_) => bloc.ev100, 'ev100', 7)
            .having((_) => bloc.iso, 'blocIso', iso100)
            .having((state) => state.ev, 'ev', 8)
            .having((state) => state.film, 'film', Film.values.first)
            .having((state) => state.iso, 'iso', iso100)
            .having((state) => state.nd, 'nd', NdValue.values.first),
        isA<MeteringDataState>()
            .having((_) => bloc.ev100, 'ev100', 2)
            .having((_) => bloc.iso, 'blocIso', iso100)
            .having((state) => state.ev, 'ev', 3)
            .having((state) => state.film, 'film', Film.values.first)
            .having((state) => state.iso, 'iso', iso100)
            .having((state) => state.nd, 'nd', NdValue.values.first),
      ],
    );
  });

  group('`MeasureEvent` tests', () {
    blocTest<MeteringBloc, MeteringState>(
      '`MeasureEvent` -> `MeteringEndedState`',
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
        isA<LoadingState>()
            .having((state) => state.film, 'film', Film.values.first)
            .having((state) => state.iso, 'iso', iso100)
            .having((state) => state.nd, 'nd', NdValue.values.first),
        isA<MeteringDataState>()
            .having((_) => bloc.isMeteringInProgress, 'isMeteringInProgress', false)
            .having((_) => bloc.ev100, 'ev100', 2)
            .having((state) => state.ev, 'ev', 2)
            .having((state) => state.film, 'film', Film.values.first)
            .having((state) => state.iso, 'iso', iso100)
            .having((state) => state.nd, 'nd', NdValue.values.first),
      ],
    );

    blocTest<MeteringBloc, MeteringState>(
      '`MeasureEvent` -> `MeteringInProgressState`',
      build: () => bloc,
      act: (bloc) async {
        bloc.add(const MeasureEvent());
        bloc.onCommunicationState(const communication_states.MeteringInProgressState(2));
      },
      verify: (_) {
        verify(() => meteringInteractor.quickVibration()).called(1);
        verify(() => communicationBloc.add(const communication_events.MeasureEvent())).called(1);
        verify(() => meteringInteractor.responseVibration()).called(1);
      },
      expect: () => [
        isA<LoadingState>()
            .having((state) => state.film, 'film', Film.values.first)
            .having((state) => state.iso, 'iso', iso100)
            .having((state) => state.nd, 'nd', NdValue.values.first),
        isA<MeteringDataState>()
            .having((_) => bloc.isMeteringInProgress, 'isMeteringInProgress', true)
            .having((_) => bloc.ev100, 'ev100', 2)
            .having((state) => state.ev, 'ev', 2)
            .having((state) => state.film, 'film', Film.values.first)
            .having((state) => state.iso, 'iso', iso100)
            .having((state) => state.nd, 'nd', NdValue.values.first),
      ],
    );
  });

  group('MeteringBloc `IsoChangedEvent` tests:', () {
    const isoValueToSet = IsoValue(200, StopType.full);
    blocTest<MeteringBloc, MeteringState>(
      'ISO change',
      setUp: () {
        when<void>(() => meteringInteractor.iso = isoValueToSet);
      },
      build: () => bloc,
      act: (bloc) async {
        bloc.add(const MeasuredEvent(1));
        bloc.add(const IsoChangedEvent(isoValueToSet));
        await Future.delayed(Dimens.durationS);
        bloc.add(const MeasureEvent());
        await Future.delayed(Dimens.durationS);
        bloc.add(const MeasuredEvent(3));
        await Future.delayed(Dimens.durationS);
      },
      verify: (_) {
        verify(() => meteringInteractor.iso = isoValueToSet).called(1);
      },
      expect: () => [
        isA<MeteringDataState>()
            .having((_) => bloc.ev100, 'ev100', 1)
            .having((state) => state.ev, 'ev', 1)
            .having((state) => state.film, 'film', Film.values.first)
            .having((state) => state.iso, 'iso', iso100)
            .having((state) => state.nd, 'nd', NdValue.values.first),
        isA<MeteringDataState>()
            .having((_) => bloc.ev100, 'ev100', 1)
            .having((_) => bloc.iso, 'blocIso', isoValueToSet)
            .having((state) => state.ev, 'ev', 2)
            .having((state) => state.film, 'film', Film.values.first)
            .having((state) => state.iso, 'iso', isoValueToSet)
            .having((state) => state.nd, 'nd', NdValue.values.first),
        isA<LoadingState>()
            .having((state) => state.film, 'film', Film.values.first)
            .having((state) => state.iso, 'iso', isoValueToSet)
            .having((state) => state.nd, 'nd', NdValue.values.first),
        isA<MeteringDataState>()
            //.having((_) => bloc.ev100, 'ev100', 3)
            .having((_) => bloc.iso, 'blocIso', isoValueToSet)
            //.having((state) => state.ev, 'ev', 4)
            .having((state) => state.film, 'film', Film.values.first)
            .having((state) => state.iso, 'iso', isoValueToSet)
            .having((state) => state.nd, 'nd', NdValue.values.first),
      ],
    );
  });
}
