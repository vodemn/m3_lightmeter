import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/providers/service_providers.dart';
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
        ServiceProviders.userPreferencesServiceOf(context),
        ServiceProviders.caffeineServiceOf(context),
        ServiceProviders.hapticsServiceOf(context),
        ServiceProviders.permissionsServiceOf(context),
        ServiceProviders.lightSensorServiceOf(context),
        ServiceProviders.volumeEventsServiceOf(context),
      )..initialize(),
      child: InheritedWidgetBase<VolumeKeysNotifier>(
        data: VolumeKeysNotifier(ServiceProviders.volumeEventsServiceOf(context)),
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
