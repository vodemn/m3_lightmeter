import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/screens/metering/bloc_metering.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/components/shared/volume_keys_notifier/notifier_volume_keys.dart';
import 'package:lightmeter/screens/metering/screen_metering.dart';

class MeteringFlow extends StatefulWidget {
  const MeteringFlow({super.key});

  @override
  State<MeteringFlow> createState() => _MeteringFlowState();
}

class _MeteringFlowState extends State<MeteringFlow> {
  @override
  Widget build(BuildContext context) {
    return MeteringInteractorProvider(
      data: MeteringInteractor(
        ServicesProvider.userPreferencesServiceOf(context),
        ServicesProvider.caffeineServiceOf(context),
        ServicesProvider.hapticsServiceOf(context),
        ServicesProvider.permissionsServiceOf(context),
        ServicesProvider.lightSensorServiceOf(context),
        ServicesProvider.volumeEventsServiceOf(context),
      )..initialize(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => MeteringCommunicationBloc()),
          BlocProvider(
            create: (context) => MeteringBloc(
              MeteringInteractorProvider.of(context),
              VolumeKeysNotifier(ServicesProvider.volumeEventsServiceOf(context)),
              context.read<MeteringCommunicationBloc>(),
            ),
          ),
        ],
        child: const MeteringScreen(),
      ),
    );
  }
}

class MeteringInteractorProvider extends InheritedWidget {
  final MeteringInteractor data;

  const MeteringInteractorProvider({
    required this.data,
    required super.child,
    super.key,
  });

  static MeteringInteractor of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<MeteringInteractorProvider>()!.data;
  }

  @override
  bool updateShouldNotify(MeteringInteractorProvider oldWidget) => false;
}
