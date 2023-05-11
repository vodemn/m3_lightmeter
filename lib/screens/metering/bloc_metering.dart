import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/communication/event_communication_metering.dart'
    as communication_events;
import 'package:lightmeter/screens/metering/communication/state_communication_metering.dart'
    as communication_states;
import 'package:lightmeter/screens/metering/event_metering.dart';
import 'package:lightmeter/screens/metering/state_metering.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class MeteringBloc extends Bloc<MeteringEvent, MeteringState> {
  final MeteringCommunicationBloc _communicationBloc;
  final UserPreferencesService _userPreferencesService;
  final MeteringInteractor _meteringInteractor;
  late final StreamSubscription<communication_states.ScreenState> _communicationSubscription;

  List<ApertureValue> get _apertureValues =>
      _equipmentProfileData.apertureValues.whereStopType(stopType);
  List<ShutterSpeedValue> get _shutterSpeedValues =>
      _equipmentProfileData.shutterSpeedValues.whereStopType(stopType);

  EquipmentProfileData _equipmentProfileData;
  StopType stopType;

  late IsoValue _iso = _userPreferencesService.iso;
  late NdValue _nd = _userPreferencesService.ndFilter;
  late Film _film = _userPreferencesService.film;
  double _ev100 = 0.0;
  bool _isMeteringInProgress = false;

  MeteringBloc(
    this._communicationBloc,
    this._userPreferencesService,
    this._meteringInteractor,
    this._equipmentProfileData,
    this.stopType,
  ) : super(
          MeteringEndedState(
            ev: 0.0,
            film: _userPreferencesService.film,
            iso: _userPreferencesService.iso,
            nd: _userPreferencesService.ndFilter,
            exposurePairs: const [],
          ),
        ) {
    _communicationSubscription = _communicationBloc.stream
        .where((state) => state is communication_states.ScreenState)
        .map((state) => state as communication_states.ScreenState)
        .listen(_onCommunicationState);

    on<EquipmentProfileChangedEvent>(_onEquipmentProfileChanged);
    on<StopTypeChangedEvent>(_onStopTypeChanged);
    on<FilmChangedEvent>(_onFilmChanged);
    on<IsoChangedEvent>(_onIsoChanged);
    on<NdChangedEvent>(_onNdChanged);
    on<MeasureEvent>(_onMeasure);
    on<MeasuredEvent>(_onMeasured);
  }

  @override
  Future<void> close() async {
    await _communicationSubscription.cancel();
    return super.close();
  }

  void _onCommunicationState(communication_states.ScreenState communicationState) {
    if (communicationState is communication_states.MeasuredState) {
      _isMeteringInProgress = communicationState is communication_states.MeteringInProgressState;
      add(MeasuredEvent(communicationState.ev100));
    }
  }

  void _onStopTypeChanged(StopTypeChangedEvent event, Emitter emit) {
    stopType = event.stopType;
    _emitMeasuredState(emit);
  }

  void _onEquipmentProfileChanged(EquipmentProfileChangedEvent event, Emitter emit) {
    _equipmentProfileData = event.equipmentProfileData;

    /// Update selected ISO value, if selected equipment profile
    /// doesn't contain currently selected value
    if (!event.equipmentProfileData.isoValues.any((v) => _iso.value == v.value)) {
      _userPreferencesService.iso = event.equipmentProfileData.isoValues.first;
      _iso = event.equipmentProfileData.isoValues.first;
    }

    /// The same for ND filter
    if (!event.equipmentProfileData.ndValues.any((v) => _nd.value == v.value)) {
      _userPreferencesService.ndFilter = event.equipmentProfileData.ndValues.first;
      _nd = event.equipmentProfileData.ndValues.first;
    }

    _emitMeasuredState(emit);
  }

  void _onFilmChanged(FilmChangedEvent event, Emitter emit) {
    if (_iso.value != event.data.iso) {
      final newIso = IsoValue.values.firstWhere(
        (e) => e.value == event.data.iso,
        orElse: () => _iso,
      );
      add(IsoChangedEvent(newIso));
    }
    _film = event.data;
    _userPreferencesService.film = event.data;
    _emitMeasuredState(emit);
  }

  void _onIsoChanged(IsoChangedEvent event, Emitter emit) {
    if (event.isoValue.value != _film.iso) {
      _film = Film.values.first;
    }
    _userPreferencesService.iso = event.isoValue;
    _iso = event.isoValue;
    _emitMeasuredState(emit);
  }

  void _onNdChanged(NdChangedEvent event, Emitter emit) {
    _userPreferencesService.ndFilter = event.ndValue;
    _nd = event.ndValue;
    _emitMeasuredState(emit);
  }

  void _onMeasure(_, Emitter emit) {
    _meteringInteractor.quickVibration();
    _communicationBloc.add(const communication_events.MeasureEvent());
    _isMeteringInProgress = true;
    emit(const LoadingState());
  }

  void _onMeasured(MeasuredEvent event, Emitter emit) {
    _meteringInteractor.responseVibration();
    _ev100 = event.ev100;
    _emitMeasuredState(emit);
  }

  void _emitMeasuredState(Emitter emit) {
    final ev = _ev100 + log2(_iso.value / 100) - _nd.stopReduction;
    emit(_isMeteringInProgress
        ? MeteringInProgressState(
            ev: ev,
            film: _film,
            iso: _iso,
            nd: _nd,
            exposurePairs: _buildExposureValues(ev),
          )
        : MeteringEndedState(
            ev: ev,
            film: _film,
            iso: _iso,
            nd: _nd,
            exposurePairs: _buildExposureValues(ev),
          ),);
  }

  List<ExposurePair> _buildExposureValues(double ev) {
    if (ev.isNaN || ev.isInfinite) {
      return List.empty();
    }

    /// Depending on the `stopType` the exposure pairs list length is multiplied by 1,2 or 3
    final int evSteps = (ev * (stopType.index + 1)).round();

    /// Basically we use 1" shutter speed as an anchor point for building the exposure pairs list.
    /// But user can exclude this value from the list using custom equipment profile.
    /// So we have to restore the index of the anchor value.
    const ShutterSpeedValue anchorShutterSpeed = ShutterSpeedValue(1, false, StopType.full);
    int anchorIndex = _shutterSpeedValues.indexOf(anchorShutterSpeed);
    if (anchorIndex < 0) {
      final filteredFullList = ShutterSpeedValue.values.whereStopType(stopType);
      final customListStartIndex = filteredFullList.indexOf(_shutterSpeedValues.first);
      final fullListAnchor = filteredFullList.indexOf(anchorShutterSpeed);
      if (customListStartIndex < fullListAnchor) {
        /// This means, that user excluded anchor value at the end,
        /// i.e. all shutter speed values are shorter than 1".
        anchorIndex = fullListAnchor - customListStartIndex;
      } else {
        /// In case user excludes anchor value at the start,
        /// we can do no adjustment.
      }
    }
    final int evOffset = anchorIndex - evSteps;

    late final int apertureOffset;
    late final int shutterSpeedOffset;
    if (evOffset >= 0) {
      apertureOffset = 0;
      shutterSpeedOffset = evOffset;
    } else {
      apertureOffset = -evOffset;
      shutterSpeedOffset = 0;
    }

    final int itemsCount = min(_apertureValues.length + shutterSpeedOffset,
            _shutterSpeedValues.length + apertureOffset,) -
        max(apertureOffset, shutterSpeedOffset);

    if (itemsCount < 0) {
      return List.empty();
    }
    return List.generate(
      itemsCount,
      (index) => ExposurePair(
        _apertureValues[index + apertureOffset],
        _film.reciprocityFailure(_shutterSpeedValues[index + shutterSpeedOffset]),
      ),
      growable: false,
    );
  }
}
