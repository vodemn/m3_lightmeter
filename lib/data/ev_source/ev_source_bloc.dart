import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart' as communication_states;

abstract class EvSourceBloc<E, S> extends Bloc<E, S> {
  final MeteringCommunicationBloc communicationBloc;
  late final StreamSubscription<communication_states.SourceState> _communicationSubscription;

  EvSourceBloc(this.communicationBloc, super.initialState) {
    _communicationSubscription = communicationBloc.stream
        .where((event) => event is communication_states.SourceState)
        .map((event) => event as communication_states.SourceState)
        .listen(onCommunicationState);
  }

  @override
  Future<void> close() async {
    await _communicationSubscription.cancel();
    super.close();
  }

  void onCommunicationState(communication_states.SourceState communicationState);
}
