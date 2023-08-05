import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/data/volume_events_service.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/screens/metering/bloc_metering.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/components/shared/volume_keys_notifier/notifier_volume_keys.dart';
import 'package:lightmeter/screens/metering/screen_metering.dart';
import 'package:lightmeter/utils/inherited_generics.dart';

class MeteringFlow extends StatefulWidget {
  const MeteringFlow({super.key});

  @override
  State<MeteringFlow> createState() => _MeteringFlowState();
}

class _MeteringFlowState extends State<MeteringFlow> {
  @override
  Widget build(BuildContext context) {
    return InheritedWidgetBase<MeteringInteractor>(
      data: MeteringInteractor(
        context.get<UserPreferencesService>(),
        context.get<CaffeineService>(),
        context.get<HapticsService>(),
        context.get<PermissionsService>(),
        context.get<LightSensorService>(),
        context.get<VolumeEventsService>(),
      )..initialize(),
      child: InheritedWidgetBase<VolumeKeysNotifier>(
        data: VolumeKeysNotifier(context.get<VolumeEventsService>()),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => MeteringCommunicationBloc()),
            BlocProvider(
              create: (context) => MeteringBloc(
                context.get<MeteringInteractor>(),
                context.get<VolumeKeysNotifier>(),
                context.read<MeteringCommunicationBloc>(),
              ),
            ),
          ],
          child: const MeteringScreen(),
        ),
      ),
    );
  }
}
