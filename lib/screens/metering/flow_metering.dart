import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/haptics_service.dart';
import 'package:lightmeter/data/models/ev_source_type.dart';
import 'package:lightmeter/data/models/photography_values/photography_value.dart';
import 'package:lightmeter/data/shared_prefs_service.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:provider/provider.dart';

import 'ev_source/camera/bloc_camera.dart';
import 'ev_source/random_ev/bloc_random_ev.dart';
import 'bloc_metering.dart';
import 'communication/bloc_communication_metering.dart';
import 'screen_metering.dart';

class MeteringFlow extends StatelessWidget {
  const MeteringFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => MeteringInteractor(
        context.read<UserPreferencesService>(),
        context.read<HapticsService>(),
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
          BlocProvider(
            create: (context) => CameraBloc(
              context.read<MeteringCommunicationBloc>(),
              context.read<MeteringInteractor>(),
            ),
          ),
          if (context.read<EvSourceType>() == EvSourceType.sensor)
            BlocProvider(
              lazy: false,
              create: (context) => RandomEvBloc(context.read<MeteringCommunicationBloc>()),
            ),
        ],
        child: const MeteringScreen(),
      ),
    );
  }
}
