import 'dart:async';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/screens/metering/components/shared/ev_source_base/bloc_base_ev_source.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/communication/event_communication_metering.dart'
    as communication_event;
import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart'
    as communication_states;
import 'package:lightmeter/utils/log_2.dart';

import 'event_container_light_sensor.dart';
import 'state_container_light_sensor.dart';

class LightSensorContainerBloc
    extends EvSourceBlocBase<LightSensorContainerEvent, LightSensorContainerState> {
  final MeteringInteractor _meteringInteractor;

  StreamSubscription<int>? _luxSubscriptions;

  LightSensorContainerBloc(
    MeteringCommunicationBloc communicationBloc,
    this._meteringInteractor,
  ) : super(
          communicationBloc,
          const LightSensorInitState(),
        );

  @override
  void onCommunicationState(communication_states.SourceState communicationState) {
    if (communicationState is communication_states.MeasureState) {
      if (_luxSubscriptions == null) {
        _luxSubscriptions = _meteringInteractor.luxStream().listen((event) {
          communicationBloc.add(communication_event.MeasuredEvent(log2(event.toDouble() / 2.5)));
        });
      } else {
        _luxSubscriptions?.cancel().then((_) => _luxSubscriptions = null);
      }
    }
  }

  @override
  Future<void> close() async {
    _luxSubscriptions?.cancel().then((_) => _luxSubscriptions = null);
    return super.close();
  }
}