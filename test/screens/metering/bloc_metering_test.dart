import 'package:bloc_test/bloc_test.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/screens/metering/bloc_metering.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/communication/event_communication_metering.dart'
    as communication_events;
import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart'
    as communication_states;
import 'package:lightmeter/screens/metering/event_metering.dart';
import 'package:lightmeter/screens/metering/state_metering.dart';
import 'package:lightmeter/screens/metering/utils/notifier_volume_keys.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockMeteringInteractor extends Mock implements MeteringInteractor {}

class _MockVolumeKeysNotifier extends Mock implements VolumeKeysNotifier {}

class _MockMeteringCommunicationBloc extends MockBloc<
    communication_events.MeteringCommunicationEvent,
    communication_states.MeteringCommunicationState> implements MeteringCommunicationBloc {}

void main() {
  late _MockMeteringInteractor meteringInteractor;
  late _MockVolumeKeysNotifier volumeKeysNotifier;
  late _MockMeteringCommunicationBloc communicationBloc;
  late MeteringBloc bloc;
  const iso100 = IsoValue(100, StopType.full);

  setUp(() {
    meteringInteractor = _MockMeteringInteractor();
    when<IsoValue>(() => meteringInteractor.iso).thenReturn(iso100);
    when<NdValue>(() => meteringInteractor.ndFilter).thenReturn(NdValue.values.first);
    when(meteringInteractor.quickVibration).thenAnswer((_) async {});
    when(meteringInteractor.responseVibration).thenAnswer((_) async {});
    when(meteringInteractor.errorVibration).thenAnswer((_) async {});

    volumeKeysNotifier = _MockVolumeKeysNotifier();
    communicationBloc = _MockMeteringCommunicationBloc();

    bloc = MeteringBloc(
      meteringInteractor,
      volumeKeysNotifier,
      communicationBloc,
    );
  });

  tearDown(() {
    bloc.close();
    //volumeKeysNotifier.dispose();
    communicationBloc.close();
  });

  group(
    '`MeasureEvent`',
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
    '`IsoChangedEvent`',
    () {
      blocTest<MeteringBloc, MeteringState>(
        'Pick different ISO (ev100 != null)',
        build: () => bloc,
        seed: () => MeteringDataState(
          ev100: 1.0,
          iso: const IsoValue(100, StopType.full),
          nd: NdValue.values.first,
          isMetering: false,
        ),
        act: (bloc) async {
          bloc.add(const IsoChangedEvent(IsoValue(200, StopType.full)));
        },
        verify: (_) {
          verify(() => meteringInteractor.iso = const IsoValue(200, StopType.full)).called(1);
        },
        expect: () => [
          isA<MeteringDataState>()
              .having((state) => state.ev100, 'ev100', 1.0)
              .having((state) => state.ev, 'ev', 2.0)
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
          iso: const IsoValue(100, StopType.full),
          nd: NdValue.values.first,
          isMetering: false,
        ),
        act: (bloc) async {
          bloc.add(const IsoChangedEvent(IsoValue(200, StopType.full)));
        },
        verify: (_) {
          verify(() => meteringInteractor.iso = const IsoValue(200, StopType.full)).called(1);
        },
        expect: () => [
          isA<MeteringDataState>()
              .having((state) => state.ev100, 'ev100', null)
              .having((state) => state.ev, 'ev', null)
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
          iso: const IsoValue(100, StopType.full),
          nd: NdValue.values.first,
          isMetering: false,
        ),
        act: (bloc) async {
          bloc.add(const IsoChangedEvent(IsoValue(100, StopType.full)));
        },
        verify: (_) {
          verifyNever(() => meteringInteractor.iso = const IsoValue(100, StopType.full));
        },
        expect: () => [],
      );

      blocTest<MeteringBloc, MeteringState>(
        'Pick different ISO & measure',
        build: () => bloc,
        seed: () => MeteringDataState(
          ev100: 1.0,
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
          verify(() => meteringInteractor.iso = const IsoValue(200, StopType.full)).called(1);
        },
        expect: () => [
          isA<MeteringDataState>()
              .having((state) => state.ev100, 'ev100', 1.0)
              .having((state) => state.ev, 'ev', 2.0)
              .having((state) => state.iso, 'iso', const IsoValue(200, StopType.full))
              .having((state) => state.nd, 'nd', NdValue.values.first)
              .having((state) => state.isMetering, 'isMetering', false),
          isA<LoadingState>(),
          isA<MeteringDataState>()
              .having((state) => state.ev100, 'ev100', 2.0)
              .having((state) => state.ev, 'ev', 3.0)
              .having((state) => state.iso, 'iso', const IsoValue(200, StopType.full))
              .having((state) => state.nd, 'nd', NdValue.values.first)
              .having((state) => state.isMetering, 'isMetering', false),
        ],
      );
    },
  );

  group(
    '`NdChangedEvent`',
    () {
      blocTest<MeteringBloc, MeteringState>(
        'Pick different ND (ev100 != null)',
        build: () => bloc,
        seed: () => MeteringDataState(
          ev100: 1.0,
          iso: const IsoValue(100, StopType.full),
          nd: NdValue.values.first,
          isMetering: false,
        ),
        act: (bloc) async {
          bloc.add(const NdChangedEvent(NdValue(2)));
        },
        verify: (_) {
          verify(() => meteringInteractor.ndFilter = const NdValue(2)).called(1);
        },
        expect: () => [
          isA<MeteringDataState>()
              .having((state) => state.ev100, 'ev100', 1.0)
              .having((state) => state.ev, 'ev', 0.0)
              .having((state) => state.iso, 'iso', const IsoValue(100, StopType.full))
              .having((state) => state.nd, 'nd', const NdValue(2))
              .having((state) => state.isMetering, 'isMetering', false),
        ],
      );

      blocTest<MeteringBloc, MeteringState>(
        'Pick different ND (ev100 = null)',
        build: () => bloc,
        seed: () => MeteringDataState(
          ev100: null,
          iso: const IsoValue(100, StopType.full),
          nd: NdValue.values.first,
          isMetering: false,
        ),
        act: (bloc) async {
          bloc.add(const NdChangedEvent(NdValue(2)));
        },
        verify: (_) {
          verify(() => meteringInteractor.ndFilter = const NdValue(2)).called(1);
        },
        expect: () => [
          isA<MeteringDataState>()
              .having((state) => state.ev100, 'ev100', null)
              .having((state) => state.ev, 'ev', null)
              .having((state) => state.iso, 'iso', const IsoValue(100, StopType.full))
              .having((state) => state.nd, 'nd', const NdValue(2))
              .having((state) => state.isMetering, 'isMetering', false),
        ],
      );

      blocTest<MeteringBloc, MeteringState>(
        'Pick same ND',
        build: () => bloc,
        seed: () => MeteringDataState(
          ev100: 1.0,
          iso: const IsoValue(100, StopType.full),
          nd: NdValue.values.first,
          isMetering: false,
        ),
        act: (bloc) async {
          bloc.add(NdChangedEvent(NdValue.values.first));
        },
        verify: (_) {
          verifyNever(() => meteringInteractor.ndFilter = NdValue.values.first);
        },
        expect: () => [],
      );

      blocTest<MeteringBloc, MeteringState>(
        'Pick different ND & measure',
        build: () => bloc,
        seed: () => MeteringDataState(
          ev100: 1.0,
          iso: const IsoValue(100, StopType.full),
          nd: NdValue.values.first,
          isMetering: false,
        ),
        act: (bloc) async {
          bloc.add(const NdChangedEvent(NdValue(2)));
          bloc.add(const MeasureEvent());
          bloc.onCommunicationState(const communication_states.MeteringEndedState(2));
        },
        verify: (_) {
          verify(() => meteringInteractor.ndFilter = const NdValue(2)).called(1);
        },
        expect: () => [
          isA<MeteringDataState>()
              .having((state) => state.ev100, 'ev100', 1.0)
              .having((state) => state.ev, 'ev', 0.0)
              .having((state) => state.iso, 'iso', const IsoValue(100, StopType.full))
              .having((state) => state.nd, 'nd', const NdValue(2))
              .having((state) => state.isMetering, 'isMetering', false),
          isA<LoadingState>(),
          isA<MeteringDataState>()
              .having((state) => state.ev100, 'ev100', 2.0)
              .having((state) => state.ev, 'ev', 1.0)
              .having((state) => state.iso, 'iso', const IsoValue(100, StopType.full))
              .having((state) => state.nd, 'nd', const NdValue(2))
              .having((state) => state.isMetering, 'isMetering', false),
        ],
      );
    },
  );

  group(
    '`EquipmentProfileChangedEvent`',
    () {
      final reducedProfile = EquipmentProfile(
        id: '0',
        name: 'Reduced',
        apertureValues: ApertureValue.values,
        ndValues: NdValue.values.getRange(0, 3).toList(),
        shutterSpeedValues: ShutterSpeedValue.values,
        isoValues: IsoValue.values.getRange(4, 23).toList(),
      );

      blocTest<MeteringBloc, MeteringState>(
        'New profile has current ISO & ND',
        build: () => bloc,
        seed: () => MeteringDataState(
          ev100: 1.0,
          iso: const IsoValue(100, StopType.full),
          nd: NdValue.values.first,
          isMetering: false,
        ),
        act: (bloc) async {
          bloc.add(EquipmentProfileChangedEvent(reducedProfile));
        },
        verify: (_) {
          verifyNever(() => meteringInteractor.iso = reducedProfile.isoValues.first);
          verifyNever(() => meteringInteractor.ndFilter = reducedProfile.ndValues.first);
          verifyNever(() => meteringInteractor.responseVibration());
        },
        expect: () => [],
      );

      blocTest<MeteringBloc, MeteringState>(
        'New profile has new ISO & current ND',
        build: () => bloc,
        seed: () => MeteringDataState(
          ev100: 1.0,
          iso: IsoValue.values[2],
          nd: NdValue.values.first,
          isMetering: false,
        ),
        act: (bloc) async {
          bloc.add(EquipmentProfileChangedEvent(reducedProfile));
        },
        verify: (_) {
          verify(() => meteringInteractor.iso = reducedProfile.isoValues.first).called(1);
          verifyNever(() => meteringInteractor.ndFilter = reducedProfile.ndValues.first);
          verify(() => meteringInteractor.responseVibration()).called(1);
        },
        expect: () => [
          isA<MeteringDataState>()
              .having((state) => state.ev100, 'ev100', 1.0)
              .having((state) => state.iso, 'iso', reducedProfile.isoValues.first)
              .having((state) => state.nd, 'nd', NdValue.values.first)
              .having((state) => state.isMetering, 'isMetering', false),
        ],
      );

      blocTest<MeteringBloc, MeteringState>(
        'New profile has current ISO & new ND',
        build: () => bloc,
        seed: () => MeteringDataState(
          ev100: 1.0,
          iso: const IsoValue(100, StopType.full),
          nd: NdValue.values[4],
          isMetering: false,
        ),
        act: (bloc) async {
          bloc.add(EquipmentProfileChangedEvent(reducedProfile));
        },
        verify: (_) {
          verifyNever(() => meteringInteractor.iso = reducedProfile.isoValues.first);
          verify(() => meteringInteractor.ndFilter = reducedProfile.ndValues.first).called(1);
          verify(() => meteringInteractor.responseVibration()).called(1);
        },
        expect: () => [
          isA<MeteringDataState>()
              .having((state) => state.ev100, 'ev100', 1.0)
              .having((state) => state.iso, 'iso', const IsoValue(100, StopType.full))
              .having((state) => state.nd, 'nd', reducedProfile.ndValues.first)
              .having((state) => state.isMetering, 'isMetering', false),
        ],
      );

      blocTest<MeteringBloc, MeteringState>(
        'New profile has new ISO & new ND',
        build: () => bloc,
        seed: () => MeteringDataState(
          ev100: 1.0,
          iso: IsoValue.values[2],
          nd: NdValue.values[4],
          isMetering: false,
        ),
        act: (bloc) async {
          bloc.add(EquipmentProfileChangedEvent(reducedProfile));
        },
        verify: (_) {
          verify(() => meteringInteractor.iso = reducedProfile.isoValues.first).called(1);
          verify(() => meteringInteractor.ndFilter = reducedProfile.ndValues.first).called(1);
          verify(() => meteringInteractor.responseVibration()).called(1);
        },
        expect: () => [
          isA<MeteringDataState>()
              .having((state) => state.ev100, 'ev100', 1.0)
              .having((state) => state.iso, 'iso', reducedProfile.isoValues.first)
              .having((state) => state.nd, 'nd', reducedProfile.ndValues.first)
              .having((state) => state.isMetering, 'isMetering', false),
        ],
      );
    },
  );

  group(
    '`Volume keys shutter action`',
    () {
      blocTest<MeteringBloc, MeteringState>(
        'Add/remove listener',
        build: () => bloc,
        verify: (_) {
          verify(() => volumeKeysNotifier.addListener(bloc.onVolumeKey)).called(1);
          verify(() => volumeKeysNotifier.removeListener(bloc.onVolumeKey)).called(1);
        },
        expect: () => [],
      );

      blocTest<MeteringBloc, MeteringState>(
        'onVolumeKey & VolumeAction.shutter',
        build: () => bloc,
        act: (bloc) async {
          bloc.onVolumeKey();
        },
        setUp: () {
          when(() => meteringInteractor.volumeAction).thenReturn(VolumeAction.shutter);
        },
        verify: (_) {},
        expect: () => [isA<LoadingState>()],
      );

      blocTest<MeteringBloc, MeteringState>(
        'onVolumeKey & VolumeAction.none',
        build: () => bloc,
        act: (bloc) async {
          bloc.onVolumeKey();
        },
        setUp: () {
          when(() => meteringInteractor.volumeAction).thenReturn(VolumeAction.none);
        },
        verify: (_) {},
        expect: () => [],
      );
    },
  );

  group(
    '`SettingOpenedEvent`/`SettingsClosedEvent`',
    () {
      blocTest<MeteringBloc, MeteringState>(
        'Settings opened & closed',
        build: () => bloc,
        act: (bloc) async {
          bloc.add(const SettingsOpenedEvent());
          bloc.add(const SettingsClosedEvent());
        },
        verify: (_) {
          verify(() => communicationBloc.add(const communication_events.SettingsOpenedEvent()))
              .called(1);
          verify(() => communicationBloc.add(const communication_events.SettingsClosedEvent()))
              .called(1);
        },
        expect: () => [],
      );
    },
  );
}
