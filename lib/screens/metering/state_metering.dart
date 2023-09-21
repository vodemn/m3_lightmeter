import 'package:flutter/material.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

@immutable
abstract class MeteringState {
  final double? ev100;
  final IsoValue iso;
  final NdValue nd;
  final bool isMetering;

  const MeteringState({
    this.ev100,
    required this.iso,
    required this.nd,
    required this.isMetering,
  });
}

class LoadingState extends MeteringState {
  const LoadingState({
    required super.iso,
    required super.nd,
  }) : super(isMetering: true);
}

class MeteringDataState extends MeteringState {
  const MeteringDataState({
    required super.ev100,
    required super.iso,
    required super.nd,
    required super.isMetering,
  });

  double? get ev => ev100 != null ? ev100! + log2(iso.value / 100) - nd.stopReduction : null;
  bool get hasError => ev == null;
}
