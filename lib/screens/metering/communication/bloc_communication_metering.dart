import 'package:flutter_bloc/flutter_bloc.dart';

import 'event_communication_metering.dart';
import 'state_communication_metering.dart';

class MeteringCommunicationBloc
    extends Bloc<MeteringCommunicationEvent, MeteringCommunicationState> {
  MeteringCommunicationBloc() : super(const InitState()) {
    // `MeasureState` is not const, so that `Bloc` treats each state as new and updates state stream
    // ignore: prefer_const_constructors
    on<MeasureEvent>((_, emit) => emit(MeasureState()));
    on<MeteringInProgressEvent>((event, emit) => emit(MeteringInProgressState(event.ev100)));
    on<MeteringEndedEvent>((event, emit) => emit(MeteringEndedState(event.ev100)));
  }
}
