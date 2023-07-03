import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/communication/event_communication_metering.dart'
    as communication_events;
import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart'
    as communication_states;
import 'package:lightmeter/screens/metering/components/shared/volume_keys_listener/listener_volume_keys.dart';
import 'package:lightmeter/screens/metering/event_metering.dart';
import 'package:lightmeter/screens/metering/state_metering.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class MeteringBloc extends Bloc<MeteringEvent, MeteringState> {
  final MeteringInteractor _meteringInteractor;
  final MeteringCommunicationBloc _communicationBloc;
  late final StreamSubscription<communication_states.ScreenState> _communicationSubscription;

  late final VolumeKeysListener _volumeKeysListener = VolumeKeysListener(
    _meteringInteractor,
    action: VolumeAction.shutter,
    onKey: (value) => add(const MeasureEvent()),
  );

  MeteringBloc(
    this._meteringInteractor,
    this._communicationBloc,
  ) : super(
          MeteringDataState(
            ev100: null,
            film: _meteringInteractor.film,
            iso: _meteringInteractor.iso,
            nd: _meteringInteractor.ndFilter,
            isMetering: false,
          ),
        ) {
    _communicationSubscription = _communicationBloc.stream
        .where((state) => state is communication_states.ScreenState)
        .map((state) => state as communication_states.ScreenState)
        .listen(onCommunicationState);

    on<EquipmentProfileChangedEvent>(_onEquipmentProfileChanged);
    on<FilmChangedEvent>(_onFilmChanged);
    on<IsoChangedEvent>(_onIsoChanged);
    on<NdChangedEvent>(_onNdChanged);
    on<MeasureEvent>(_onMeasure, transformer: droppable());
    on<MeasuredEvent>(_onMeasured);
    on<MeasureErrorEvent>(_onMeasureError);
  }

  @override
  void onTransition(Transition<MeteringEvent, MeteringState> transition) {
    super.onTransition(transition);
    if (transition.nextState is MeteringDataState) {
      final nextState = transition.nextState as MeteringDataState;
      if (transition.currentState is LoadingState ||
          transition.currentState is MeteringDataState &&
              (transition.currentState as MeteringDataState).ev != nextState.ev) {
        if (nextState.hasError) {
          _meteringInteractor.errorVibration();
        } else {
          _meteringInteractor.responseVibration();
        }
      }
    }
  }

  @override
  Future<void> close() async {
    await _volumeKeysListener.dispose();
    await _communicationSubscription.cancel();
    return super.close();
  }

  @visibleForTesting
  void onCommunicationState(communication_states.ScreenState communicationState) {
    if (communicationState is communication_states.MeasuredState) {
      _handleEv100(
        communicationState.ev100,
        isMetering: communicationState is communication_states.MeteringInProgressState,
      );
    }
  }

  void _onEquipmentProfileChanged(EquipmentProfileChangedEvent event, Emitter emit) {
    bool willUpdateMeasurements = false;

    /// Update selected ISO value and discard selected film, if selected equipment profile
    /// doesn't contain currently selected value
    IsoValue iso = state.iso;
    Film film = state.film;
    if (!event.equipmentProfileData.isoValues.any((v) => state.iso.value == v.value)) {
      _meteringInteractor.iso = event.equipmentProfileData.isoValues.first;
      iso = event.equipmentProfileData.isoValues.first;
      _meteringInteractor.film = Film.values.first;
      film = Film.values.first;
      willUpdateMeasurements = true;
    }

    /// The same for ND filter
    NdValue nd = state.nd;
    if (!event.equipmentProfileData.ndValues.any((v) => state.nd.value == v.value)) {
      _meteringInteractor.ndFilter = event.equipmentProfileData.ndValues.first;
      nd = event.equipmentProfileData.ndValues.first;
      willUpdateMeasurements = true;
    }

    if (willUpdateMeasurements) {
      emit(
        MeteringDataState(
          ev100: state.ev100,
          film: film,
          iso: iso,
          nd: nd,
          isMetering: state.isMetering,
        ),
      );
    }
  }

  void _onFilmChanged(FilmChangedEvent event, Emitter emit) {
    if (state.film.name != event.film.name) {
      _meteringInteractor.film = event.film;

      /// Find `IsoValue` with matching value
      IsoValue iso = state.iso;
      if (state.iso.value != event.film.iso && event.film != const Film.other()) {
        iso = IsoValue.values.firstWhere(
          (e) => e.value == event.film.iso,
          orElse: () => state.iso,
        );
        _meteringInteractor.iso = iso;
      }

      /// If user selects 'Other' film we preserve currently selected ISO
      /// and therefore only discard reciprocity formula
      emit(
        MeteringDataState(
          ev100: state.ev100,
          film: event.film,
          iso: iso,
          nd: state.nd,
          isMetering: state.isMetering,
        ),
      );
    }
  }

  void _onIsoChanged(IsoChangedEvent event, Emitter emit) {
    /// Discard currently selected film even if ISO is the same,
    /// because, for example, Fomapan 400 and any Ilford 400
    /// have different reciprocity formulas
    _meteringInteractor.film = Film.values.first;

    if (state.iso != event.isoValue) {
      _meteringInteractor.iso = event.isoValue;
      emit(
        MeteringDataState(
          ev100: state.ev100,
          film: Film.values.first,
          iso: event.isoValue,
          nd: state.nd,
          isMetering: state.isMetering,
        ),
      );
    }
  }

  void _onNdChanged(NdChangedEvent event, Emitter emit) {
    if (state.nd != event.ndValue) {
      _meteringInteractor.ndFilter = event.ndValue;
      emit(
        MeteringDataState(
          ev100: state.ev100,
          film: state.film,
          iso: state.iso,
          nd: event.ndValue,
          isMetering: state.isMetering,
        ),
      );
    }
  }

  void _onMeasure(MeasureEvent _, Emitter emit) {
    _meteringInteractor.quickVibration();
    _communicationBloc.add(const communication_events.MeasureEvent());
    emit(
      LoadingState(
        film: state.film,
        iso: state.iso,
        nd: state.nd,
      ),
    );
  }

  void _handleEv100(double? ev100, {required bool isMetering}) {
    if (ev100 == null || ev100.isNaN || ev100.isInfinite) {
      add(MeasureErrorEvent(isMetering: isMetering));
    } else {
      add(MeasuredEvent(ev100, isMetering: isMetering));
    }
  }

  void _onMeasured(MeasuredEvent event, Emitter emit) {
    emit(
      MeteringDataState(
        ev100: event.ev100,
        film: state.film,
        iso: state.iso,
        nd: state.nd,
        isMetering: event.isMetering,
      ),
    );
  }

  void _onMeasureError(MeasureErrorEvent event, Emitter emit) {
    emit(
      MeteringDataState(
        ev100: null,
        film: state.film,
        iso: state.iso,
        nd: state.nd,
        isMetering: event.isMetering,
      ),
    );
  }
}
