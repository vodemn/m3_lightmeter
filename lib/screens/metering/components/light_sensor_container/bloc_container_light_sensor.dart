import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/communication/event_communication_metering.dart'
    as communication_event;
import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart'
    as communication_states;
import 'package:lightmeter/screens/metering/components/light_sensor_container/event_container_light_sensor.dart';
import 'package:lightmeter/screens/metering/components/light_sensor_container/state_container_light_sensor.dart';
import 'package:lightmeter/screens/metering/components/shared/ev_source_base/bloc_base_ev_source.dart';
import 'package:lightmeter/utils/log_2.dart';

class LightSensorContainerBloc
    extends EvSourceBlocBase<LightSensorContainerEvent, LightSensorContainerState> {
  final MeteringInteractor _meteringInteractor;

  StreamSubscription<int>? _luxSubscriptions;

  LightSensorContainerBloc(
    this._meteringInteractor,
    MeteringCommunicationBloc communicationBloc,
  ) : super(
          communicationBloc,
          const LightSensorContainerState(null),
        ) {
    on<StartLuxMeteringEvent>(_onStartLuxMeteringEvent);
    on<LuxMeteringEvent>(_onLuxMeteringEvent);
    on<CancelLuxMeteringEvent>(_onCancelLuxMeteringEvent);
  }

  @override
  void onCommunicationState(communication_states.SourceState communicationState) {
    switch (communicationState) {
      case communication_states.MeasureState():
        if (_luxSubscriptions == null) {
          add(const StartLuxMeteringEvent());
        } else {
          add(const CancelLuxMeteringEvent());
        }
      case communication_states.SettingsOpenedState():
        add(const CancelLuxMeteringEvent());
      default:
    }
  }

  @override
  Future<void> close() async {
    communicationBloc.add(communication_event.MeteringEndedEvent(state.ev100));
    _luxSubscriptions?.cancel().then((_) => _luxSubscriptions = null);
    return super.close();
  }

  void _onStartLuxMeteringEvent(StartLuxMeteringEvent event, _) {
    _luxSubscriptions = _meteringInteractor.luxStream().listen((lux) => add(LuxMeteringEvent(lux)));
  }

  void _onLuxMeteringEvent(LuxMeteringEvent event, Emitter<LightSensorContainerState> emit) {
    final ev100 = log2(event.lux.toDouble() / 2.5) + _meteringInteractor.lightSensorEvCalibration;
    emit(LightSensorContainerState(ev100));
    communicationBloc.add(communication_event.MeteringInProgressEvent(ev100));
  }

  void _onCancelLuxMeteringEvent(CancelLuxMeteringEvent event, _) {
    communicationBloc.add(communication_event.MeteringEndedEvent(state.ev100));
    _luxSubscriptions?.cancel().then((_) => _luxSubscriptions = null);
  }
}
