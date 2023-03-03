import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';
import 'package:provider/provider.dart';

import 'bloc_metering.dart';
import 'communication/bloc_communication_metering.dart';
import 'screen_metering.dart';

class MeteringFlow extends StatefulWidget {
  const MeteringFlow({super.key});

  @override
  State<MeteringFlow> createState() => _MeteringFlowState();
}

class _MeteringFlowState extends State<MeteringFlow> {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => MeteringInteractor(
        context.read<UserPreferencesService>(),
        context.read<CaffeineService>(),
        context.read<HapticsService>(),
        context.read<PermissionsService>(),
        context.read<LightSensorService>(),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => MeteringCommunicationBloc()),
          BlocProvider(
            create: (context) => MeteringBloc(
              context.read<MeteringCommunicationBloc>(),
              context.read<UserPreferencesService>(),
              context.read<MeteringInteractor>(),
              context.read<StopType>(),
            ),
          ),
        ],
        child: const MeteringScreen(),
      ),
    );
  }
}
