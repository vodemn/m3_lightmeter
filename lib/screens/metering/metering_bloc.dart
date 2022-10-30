import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/models/exposure_pair.dart';
import 'package:lightmeter/models/photography_value.dart';

import 'metering_event.dart';
import 'metering_state.dart';

class MeteringBloc extends Bloc<MeteringEvent, MeteringState> {
  final StopType stopType;
  late final _apertureValues = apertureValues.whereStopType(stopType);
  late final _shutterSpeedValues = shutterSpeedValues.whereStopType(stopType);
  late final _isoValues = isoValues.whereStopType(stopType);
  final _random = Random();

  MeteringBloc(this.stopType)
      : super(
          const MeteringState(
            iso: 100,
            ev: 21.3,
            evCompensation: 0.0,
            nd: 0.0,
            exposurePairs: [],
          ),
        ) {
    on<MeasureEvent>(_onMeasure);

    add(const MeasureEvent());
  }

  /// https://www.scantips.com/lights/exposurecalc.html
  void _onMeasure(_, Emitter emit) {
    double log2(double x) => log(x) / log(2);

    final aperture = _apertureValues[_random.nextInt(_apertureValues.length)];
    final shutterSpeed = _shutterSpeedValues[_random.nextInt(_shutterSpeedValues.thirdStops().length)];
    final iso = _isoValues[_random.nextInt(_isoValues.thirdStops().length)];

    final evAtSystemIso = log2(pow(aperture.value, 2).toDouble()) - log2(shutterSpeed.value);
    final ev = evAtSystemIso - log2(iso.value / state.iso);
    final exposurePairs = _buildExposureValues(ev);

    emit(MeteringState(
      iso: state.iso,
      ev: ev,
      evCompensation: state.evCompensation,
      nd: state.nd,
      exposurePairs: exposurePairs,
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
