import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/ev_source/camera/bloc_camera.dart';
import 'package:lightmeter/data/ev_source/ev_source_type.dart';
import 'package:lightmeter/data/ev_source/random_ev/bloc_random_ev.dart';
import 'package:lightmeter/models/photography_value.dart';
import 'package:lightmeter/screens/metering/bloc_metering.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';

import 'screen_metering.dart';

class MeteringFlow extends StatelessWidget {
  const MeteringFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MeteringCommunicationBloc()),
        BlocProvider(
          create: (context) => MeteringBloc(
            context.read<MeteringCommunicationBloc>(),
            context.read<StopType>(),
          ),
        ),
        BlocProvider(create: (context) => CameraBloc(context.read<MeteringCommunicationBloc>())),
        if (context.read<EvSourceType>() == EvSourceType.mock)
          BlocProvider(
            lazy: false,
            create: (context) => RandomEvBloc(context.read<MeteringCommunicationBloc>()),
          ),
      ],
      child: const MeteringScreen(),
    );
  }
}
