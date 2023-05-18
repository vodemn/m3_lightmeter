import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/caffeine_service.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/light_sensor_service.dart';
import 'package:lightmeter/data/permissions_service.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/providers/equipment_profile_provider.dart';
import 'package:lightmeter/screens/metering/bloc_metering.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/screen_metering.dart';
import 'package:lightmeter/utils/inherited_generics.dart';
import 'package:m3_lightmeter_resources/m3_lightmeter_resources.dart';

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
        context.get<UserPreferencesService>(),
        context.get<CaffeineService>(),
        context.get<HapticsService>(),
        context.get<PermissionsService>(),
        context.read<LightSensorService>(),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => MeteringCommunicationBloc()),
          BlocProvider(
            create: (context) => MeteringBloc(
              context.read<MeteringCommunicationBloc>(),
              context.read<MeteringInteractor>(),
              context.get<EquipmentProfile>(),
              context.get<StopType>(),
            ),
          ),
        ],
        child: const MeteringScreen(),
      ),
    );
  }
}
