import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/photography_values/aperture_value.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/photography_values/photography_value.dart';
import 'package:lightmeter/data/models/photography_values/shutter_speed_value.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/screens/metering/communication/event_communication_metering.dart' as communication_events;
import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart' as communication_states;
import 'package:lightmeter/utils/log_2.dart';

import 'communication/bloc_communication_metering.dart';
import 'event_metering.dart';
import 'state_metering.dart';

class MeteringBloc extends Bloc<MeteringEvent, MeteringState> {
  final MeteringCommunicationBloc _communicationBloc;
  final UserPreferencesService _userPreferencesService;
  late final StreamSubscription<communication_states.ScreenState> _communicationSubscription;

  List<ApertureValue> get _apertureValues => apertureValues.whereStopType(stopType);
  List<ShutterSpeedValue> get _shutterSpeedValues => shutterSpeedValues.whereStopType(stopType);

  StopType stopType;

  MeteringBloc(
    this._communicationBloc,
    this._userPreferencesService,
    this.stopType,
  ) : super(
          MeteringState(
            iso: _userPreferencesService.iso,
            ev: 0.0,
            evCompensation: 0.0,
            nd: _userPreferencesService.ndFilter,
            exposurePairs: [],
          ),
        ) {
    _communicationSubscription = _communicationBloc.stream
        .where((state) => state is communication_states.ScreenState)
        .map((state) => state as communication_states.ScreenState)
        .listen(_onCommunicationState);

    on<StopTypeChangedEvent>(_onStopTypeChanged);
    on<IsoChangedEvent>(_onIsoChanged);
    on<NdChangedEvent>(_onNdChanged);
    on<MeasureEvent>((_, __) => _communicationBloc.add(const communication_events.MeasureEvent()));
    on<MeasuredEvent>(_onMeasured);

    add(const MeasureEvent());
  }

  @override
  Future<void> close() async {
    await _communicationSubscription.cancel();
    return super.close();
  }

  void _onCommunicationState(communication_states.ScreenState communicationState) {
    if (communicationState is communication_states.MeasuredState) {
      add(MeasuredEvent(communicationState.ev100));
    }
  }

  void _onStopTypeChanged(StopTypeChangedEvent event, Emitter emit) {
    stopType = event.stopType;
    emit(MeteringState(
      iso: state.iso,
      ev: state.ev,
      evCompensation: state.evCompensation,
      nd: state.nd,
      exposurePairs: _buildExposureValues(state.ev),
    ));
  }

  void _onIsoChanged(IsoChangedEvent event, Emitter emit) {
    _userPreferencesService.iso = event.isoValue;
    final ev = state.ev + log2(event.isoValue.value / state.iso.value);
    emit(MeteringState(
      iso: event.isoValue,
      ev: ev,
      evCompensation: state.evCompensation,
      nd: state.nd,
      exposurePairs: _buildExposureValues(ev),
    ));
  }

  void _onNdChanged(NdChangedEvent event, Emitter emit) {
    _userPreferencesService.ndFilter = event.ndValue;
    final ev = state.ev - event.ndValue.stopReduction + state.nd.stopReduction;
    emit(MeteringState(
      iso: state.iso,
      ev: ev,
      evCompensation: state.evCompensation,
      nd: event.ndValue,
      exposurePairs: _buildExposureValues(ev),
    ));
  }

  void _onMeasured(MeasuredEvent event, Emitter emit) {
    final ev = event.ev100 + log2(state.iso.value / 100);
    emit(MeteringState(
      iso: state.iso,
      ev: ev,
      evCompensation: state.evCompensation,
      nd: state.nd,
      exposurePairs: _buildExposureValues(ev),
    ));
  }

  List<ExposurePair> _buildExposureValues(double ev) {
    late final int evSteps;
    switch (stopType) {
      case StopType.full:
        evSteps = ev.floor();
        break;
      case StopType.half:
        evSteps = (ev / 0.5).floor();
        break;
      case StopType.third:
        evSteps = (ev / 0.3).floor();
        break;
    }
    final evOffset = _shutterSpeedValues.indexOf(const ShutterSpeedValue(1, false, StopType.full)) - evSteps;

    late final int apertureOffset;
    late final int shutterSpeedOffset;
    if (evOffset >= 0) {
      apertureOffset = 0;
      shutterSpeedOffset = evOffset;
    } else {
      apertureOffset = -evOffset;
      shutterSpeedOffset = 0;
    }

    int itemsCount = min(_apertureValues.length + shutterSpeedOffset, _shutterSpeedValues.length + apertureOffset) -
        max(apertureOffset, shutterSpeedOffset);

    if (itemsCount < 0) {
      return List.empty(growable: false);
    }
    return List.generate(
      itemsCount,
      (index) => ExposurePair(
        _apertureValues[index + apertureOffset],
        _shutterSpeedValues[index + shutterSpeedOffset],
      ),
      growable: false,
    );
  }
}
