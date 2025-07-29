import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lightmeter/screens/metering/communication/event_communication_metering.dart';
import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart';

class MeteringCommunicationBloc extends Bloc<MeteringCommunicationEvent, MeteringCommunicationState> {
  MeteringCommunicationBloc() : super(const InitState()) {
    // `MeasureState` is not const, so that `Bloc` treats each state as new and updates state stream
    // ignore: prefer_const_constructors
    on<MeasureEvent>((_, emit) => emit(MeasureState()));
    on<EquipmentProfileChangedEvent>((event, emit) => emit(EquipmentProfileChangedState(event.profile)));
    on<MeteringInProgressEvent>((event, emit) => emit(MeteringInProgressState(event.ev100)));
    on<MeteringEndedEvent>((event, emit) => emit(MeteringEndedState(event.ev100, photoPath: event.photoPath)));
    on<ScreenOnTopOpenedEvent>((_, emit) => emit(const SettingsOpenedState()));
    on<ScreenOnTopClosedEvent>((_, emit) => emit(const SettingsClosedState()));
  }
}
