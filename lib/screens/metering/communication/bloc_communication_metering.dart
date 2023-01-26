import 'package:flutter_bloc/flutter_bloc.dart';

import 'event_communication_metering.dart';
import 'state_communication_metering.dart';

class MeteringCommunicationBloc
    extends Bloc<MeteringCommunicationEvent, MeteringCommunicationState> {
  MeteringCommunicationBloc() : super(const InitState()) {
    on<MeasureEvent>((_, emit) => emit(const MeasureState()));
    on<MeasuredEvent>((event, emit) => emit(MeasuredState(event.ev100)));
  }
}
