import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/models/aperture_value.dart';
import 'package:lightmeter/models/exposure_pair.dart';
import 'package:lightmeter/models/iso_value.dart';
import 'package:lightmeter/models/nd_value.dart';
import 'package:lightmeter/models/photography_value.dart';
import 'package:lightmeter/models/shutter_speed_value.dart';
import 'package:lightmeter/utils/log_2.dart';

import 'metering_event.dart';
import 'metering_state.dart';

class MeteringBloc extends Bloc<MeteringEvent, MeteringState> {
  List<ApertureValue> get _apertureValues => apertureValues.whereStopType(stopType);
  List<ShutterSpeedValue> get _shutterSpeedValues => shutterSpeedValues.whereStopType(stopType);
  final _random = Random();

  StopType stopType;

  MeteringBloc(this.stopType)
      : super(
          MeteringState(
            iso: isoValues.where((element) => element.value == 100).first,
            ev: 21.3,
            evCompensation: 0.0,
            nd: ndValues.first,
            exposurePairs: [],
          ),
        ) {
    on<StopTypeChangedEvent>(_onStopTypeChanged);
    on<IsoChangedEvent>(_onIsoChanged);
    on<NdChangedEvent>(_onNdChanged);
    on<MeasureEvent>(_onMeasure);

    add(const MeasureEvent());
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
    final ev = state.ev - event.ndValue.stopReduction + state.nd.stopReduction;
    emit(MeteringState(
      iso: state.iso,
      ev: ev,
      evCompensation: state.evCompensation,
      nd: event.ndValue,
      exposurePairs: _buildExposureValues(ev),
    ));
  }

  /// https://www.scantips.com/lights/exposurecalc.html
  void _onMeasure(_, Emitter emit) {
    final aperture = _apertureValues[_random.nextInt(_apertureValues.length)];
    final shutterSpeed = _shutterSpeedValues[_random.nextInt(_shutterSpeedValues.thirdStops().length)];
    final iso = isoValues[_random.nextInt(isoValues.thirdStops().length)];

    final evAtSystemIso = log2(pow(aperture.value, 2).toDouble() / shutterSpeed.value);
    final ev = evAtSystemIso - log2(iso.value / state.iso.value);

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
