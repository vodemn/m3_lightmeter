import 'dart:math';
import 'package:lightmeter/screens/metering/ev_source/ev_source_bloc.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/communication/event_communication_metering.dart'
    as communication_event;
import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart'
    as communication_states;

import 'event_random_ev.dart';
import 'state_random_ev.dart';

class RandomEvBloc extends EvSourceBloc<RandomEvEvent, RandomEvState> {
  final random = Random();

  RandomEvBloc(MeteringCommunicationBloc communicationBloc)
      : super(
          communicationBloc,
          RandomEvState(Random().nextDouble() * 15),
        );

  @override
  void onCommunicationState(communication_states.SourceState communicationState) {
    if (communicationState is communication_states.MeasureState) {
      communicationBloc.add(communication_event.MeasuredEvent(random.nextDouble() * 15));
    }
  }
}
