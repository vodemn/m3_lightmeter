import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/volume_action.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/providers/logbook_photos_provider.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/communication/event_communication_metering.dart' as communication_events;
import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart' as communication_states;
import 'package:lightmeter/screens/metering/event_metering.dart';
import 'package:lightmeter/screens/metering/state_metering.dart';
import 'package:lightmeter/screens/metering/utils/notifier_volume_keys.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class MeteringBloc extends Bloc<MeteringEvent, MeteringState> {
  final MeteringInteractor _meteringInteractor;
  final VolumeKeysNotifier _volumeKeysNotifier;
  final MeteringCommunicationBloc _communicationBloc;
  final LogbookPhotosProviderState _logbookPhotosProvider;
  late final StreamSubscription<communication_states.ScreenState> _communicationSubscription;

  MeteringBloc(
    this._meteringInteractor,
    this._volumeKeysNotifier,
    this._communicationBloc,
    this._logbookPhotosProvider,
  ) : super(
          MeteringDataState(
            ev100: null,
            iso: _meteringInteractor.iso,
            nd: _meteringInteractor.ndFilter,
            isMetering: false,
          ),
        ) {
    _volumeKeysNotifier.addListener(onVolumeKey);
    _communicationSubscription = _communicationBloc.stream
        .where((state) => state is communication_states.ScreenState)
        .map((state) => state as communication_states.ScreenState)
        .listen(onCommunicationState);

    on<EquipmentProfileChangedEvent>(_onEquipmentProfileChanged);
    on<IsoChangedEvent>(_onIsoChanged);
    on<NdChangedEvent>(_onNdChanged);
    on<MeasureEvent>(_onMeasure, transformer: droppable());
    on<MeasuredEvent>(_onMeasured);
    on<MeasureErrorEvent>(_onMeasureError);
    on<ScreenOnTopOpenedEvent>(_onSettingsOpened);
    on<ScreenOnTopClosedEvent>(_onSettingsClosed);
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
    _volumeKeysNotifier.removeListener(onVolumeKey);
    await _communicationSubscription.cancel();
    return super.close();
  }

  @visibleForTesting
  void onCommunicationState(communication_states.ScreenState communicationState) {
    if (communicationState is communication_states.MeasuredState) {
      String? photoPath;
      if (communicationState case final communication_states.MeteringEndedState state) {
        photoPath = state.photoPath;
      }
      _handleEv100(
        communicationState.ev100,
        isMetering: communicationState is communication_states.MeteringInProgressState,
        photoPath: photoPath,
      );
    }
  }

  void _onEquipmentProfileChanged(EquipmentProfileChangedEvent event, Emitter emit) {
    bool willUpdateMeasurements = false;

    /// Update selected ISO value and discard selected film, if selected equipment profile
    /// doesn't contain currently selected value
    IsoValue iso = state.iso;
    if (!event.equipmentProfileData.isoValues.any((v) => state.iso.value == v.value)) {
      _meteringInteractor.iso = event.equipmentProfileData.isoValues.first;
      iso = event.equipmentProfileData.isoValues.first;
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
          iso: iso,
          nd: nd,
          isMetering: state.isMetering,
        ),
      );
    }
  }

  void _onIsoChanged(IsoChangedEvent event, Emitter emit) {
    if (state.iso != event.isoValue) {
      _meteringInteractor.iso = event.isoValue;
      emit(
        MeteringDataState(
          ev100: state.ev100,
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
        iso: state.iso,
        nd: state.nd,
      ),
    );
  }

  void _handleEv100(double? ev100, {required bool isMetering, String? photoPath}) {
    if (ev100 == null || ev100.isNaN || ev100.isInfinite) {
      add(MeasureErrorEvent(isMetering: isMetering));
    } else {
      add(
        MeasuredEvent(
          ev100,
          isMetering: isMetering,
          photoPath: photoPath,
        ),
      );
    }
  }

  void _onMeasured(MeasuredEvent event, Emitter emit) {
    if (event.photoPath case final path?) {
      _logbookPhotosProvider.addPhotoIfPossible(
        path,
        ev100: event.ev100,
        iso: state.iso.value,
        nd: state.nd.value,
      );
    }
    emit(
      MeteringDataState(
        ev100: event.ev100,
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
        iso: state.iso,
        nd: state.nd,
        isMetering: event.isMetering,
      ),
    );
  }

  @visibleForTesting
  void onVolumeKey() {
    if (_meteringInteractor.volumeAction == VolumeAction.shutter) {
      add(const MeasureEvent());
    }
  }

  void _onSettingsOpened(ScreenOnTopOpenedEvent _, Emitter __) {
    _communicationBloc.add(const communication_events.ScreenOnTopOpenedEvent());
  }

  void _onSettingsClosed(ScreenOnTopClosedEvent _, Emitter __) {
    _communicationBloc.add(const communication_events.ScreenOnTopClosedEvent());
  }
}
