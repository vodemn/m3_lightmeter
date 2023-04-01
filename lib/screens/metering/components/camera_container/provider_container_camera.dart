import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/data/models/film.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

import 'bloc_container_camera.dart';
import 'widget_container_camera.dart';

class CameraContainerProvider extends StatelessWidget {
  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final Film film;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<Film> onFilmChanged;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;
  final List<ExposurePair> exposurePairs;

  const CameraContainerProvider({
    required this.fastest,
    required this.slowest,
    required this.film,
    required this.iso,
    required this.nd,
    required this.onFilmChanged,
    required this.onIsoChanged,
    required this.onNdChanged,
    required this.exposurePairs,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => CameraContainerBloc(
        context.read<MeteringInteractor>(),
        context.read<MeteringCommunicationBloc>(),
      ),
      child: CameraContainer(
        fastest: fastest,
        slowest: slowest,
        film: film,
        iso: iso,
        nd: nd,
        onFilmChanged: onFilmChanged,
        onIsoChanged: onIsoChanged,
        onNdChanged: onNdChanged,
        exposurePairs: exposurePairs,
      ),
    );
  }
}
