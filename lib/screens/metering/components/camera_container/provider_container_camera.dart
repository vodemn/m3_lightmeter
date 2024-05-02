import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/platform_config.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/components/camera_container/bloc_container_camera.dart';
import 'package:lightmeter/screens/metering/components/camera_container/event_container_camera.dart';
import 'package:lightmeter/screens/metering/components/camera_container/widget_container_camera.dart';
import 'package:lightmeter/screens/metering/flow_metering.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

class CameraContainerProvider extends StatelessWidget {
  final ExposurePair? fastest;
  final ExposurePair? slowest;
  final IsoValue iso;
  final NdValue nd;
  final ValueChanged<IsoValue> onIsoChanged;
  final ValueChanged<NdValue> onNdChanged;
  final List<ExposurePair> exposurePairs;
  final ValueChanged<ExposurePair> onExposurePairTap;

  const CameraContainerProvider({
    required this.fastest,
    required this.slowest,
    required this.iso,
    required this.nd,
    required this.onIsoChanged,
    required this.onNdChanged,
    required this.exposurePairs,
    required this.onExposurePairTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CameraContainerBloc>(
      lazy: false,
      create: (context) => (PlatformConfig.cameraStubImage.isNotEmpty
          ? MockCameraContainerBloc(
              MeteringInteractorProvider.of(context),
              context.read<MeteringCommunicationBloc>(),
              ServicesProvider.of(context).analytics,
            )
          : CameraContainerBloc(
              MeteringInteractorProvider.of(context),
              context.read<MeteringCommunicationBloc>(),
              ServicesProvider.of(context).analytics,
            ))
        ..add(const RequestPermissionEvent()),
      child: CameraContainer(
        fastest: fastest,
        slowest: slowest,
        iso: iso,
        nd: nd,
        onIsoChanged: onIsoChanged,
        onNdChanged: onNdChanged,
        exposurePairs: exposurePairs,
        onExposurePairTap: onExposurePairTap,
      ),
    );
  }
}
