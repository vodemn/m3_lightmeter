import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/photography_values/iso_value.dart';
import 'package:lightmeter/data/models/photography_values/nd_value.dart';

abstract class MeteringState {
  const MeteringState();
}

class LoadingState extends MeteringState {
  const LoadingState();
}

abstract class MeteringDataState extends MeteringState {
  final double ev;
  final IsoValue iso;
  final NdValue nd;
  final List<ExposurePair> exposurePairs;

  const MeteringDataState({
    required this.ev,
    required this.iso,
    required this.nd,
    required this.exposurePairs,
  });

  ExposurePair? get fastest => exposurePairs.isEmpty ? null : exposurePairs.first;
  ExposurePair? get slowest => exposurePairs.isEmpty ? null : exposurePairs.last;
}

class MeteringInProgressState extends MeteringDataState {
  MeteringInProgressState({
    required super.ev,
    required super.iso,
    required super.nd,
    required super.exposurePairs,
  });
}

class MeteringEndedState extends MeteringDataState {
  MeteringEndedState({
    required super.ev,
    required super.iso,
    required super.nd,
    required super.exposurePairs,
  });
}
