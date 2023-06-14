import 'package:bloc_test/bloc_test.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/communication/event_communication_metering.dart';
import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart';
import 'package:test/test.dart';

void main() {
  late MeteringCommunicationBloc bloc;

  setUp(() {
    bloc = MeteringCommunicationBloc();
  });

  tearDown(() {
    bloc.close();
  });

  group(
    '`MeasureEvent` tests',
    () {
      blocTest<MeteringCommunicationBloc, MeteringCommunicationState>(
        'Multiple consequtive measure events',
        build: () => bloc,
        act: (bloc) async {
          bloc.add(const MeasureEvent());
          bloc.add(const MeasureEvent());
          bloc.add(const MeasureEvent());
          bloc.add(const MeasureEvent());
        },
        expect: () => [
          isA<MeasureState>(),
          isA<MeasureState>(),
          isA<MeasureState>(),
          isA<MeasureState>(),
        ],
      );

      blocTest<MeteringCommunicationBloc, MeteringCommunicationState>(
        'Continuous metering simulation',
        build: () => bloc,
        act: (bloc) async {
          bloc.add(const MeasureEvent());
          bloc.add(const MeteringInProgressEvent(1));
          bloc.add(const MeteringInProgressEvent(null));
          bloc.add(const MeteringInProgressEvent(null));
          bloc.add(const MeteringInProgressEvent(2));
          bloc.add(const MeasureEvent());
          bloc.add(const MeteringEndedEvent(2));
        },
        expect: () => [
          isA<MeasureState>(),
          isA<MeteringInProgressState>().having((state) => state.ev100, 'ev100', 1),
          isA<MeteringInProgressState>().having((state) => state.ev100, 'ev100', null),
          isA<MeteringInProgressState>().having((state) => state.ev100, 'ev100', 2),
          isA<MeasureState>(),
          isA<MeteringEndedState>().having((state) => state.ev100, 'ev100', 2),
        ],
      );
    },
  );

  group(
    '`MeteringInProgressEvent` tests',
    () {
      blocTest<MeteringCommunicationBloc, MeteringCommunicationState>(
        'Multiple consequtive in progress events',
        build: () => bloc,
        act: (bloc) async {
          bloc.add(const MeteringInProgressEvent(1));
          bloc.add(const MeteringInProgressEvent(1));
          bloc.add(const MeteringInProgressEvent(1));
          bloc.add(const MeteringInProgressEvent(null));
          bloc.add(const MeteringInProgressEvent(null));
          bloc.add(const MeteringInProgressEvent(2));
        },
        expect: () => [
          isA<MeteringInProgressState>().having((state) => state.ev100, 'ev100', 1),
          isA<MeteringInProgressState>().having((state) => state.ev100, 'ev100', null),
          isA<MeteringInProgressState>().having((state) => state.ev100, 'ev100', 2),
        ],
      );
    },
  );

  group(
    '`MeteringEndedEvent` tests',
    () {
      blocTest<MeteringCommunicationBloc, MeteringCommunicationState>(
        'Multiple consequtive ended events',
        build: () => bloc,
        act: (bloc) async {
          bloc.add(const MeteringEndedEvent(1));
        },
        expect: () => [
          isA<MeteringEndedState>().having((state) => state.ev100, 'ev100', 1),
        ],
      );
    },
  );
}
