import 'package:flutter/material.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

@immutable
abstract class MeteringState {
  const MeteringState();
}

class LoadingState extends MeteringState {
  const LoadingState();
}

class MeteringDataState extends MeteringState {
  final double? ev;
  final Film film;
  final IsoValue iso;
  final NdValue nd;
  final List<ExposurePair> exposurePairs;
  final bool continuousMetering;

  const MeteringDataState({
    required this.ev,
    required this.film,
    required this.iso,
    required this.nd,
    required this.exposurePairs,
    required this.continuousMetering,
  });

  ExposurePair? get fastest => exposurePairs.isEmpty ? null : exposurePairs.first;
  ExposurePair? get slowest => exposurePairs.isEmpty ? null : exposurePairs.last;
  bool get hasError => ev == null;
}
