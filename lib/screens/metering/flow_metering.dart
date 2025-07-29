import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/providers/logbook_photos_provider.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/screens/metering/bloc_metering.dart';
import 'package:lightmeter/screens/metering/communication/bloc_communication_metering.dart';
import 'package:lightmeter/screens/metering/screen_metering.dart';
import 'package:lightmeter/screens/metering/utils/notifier_volume_keys.dart';

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
        ServicesProvider.of(context).userPreferencesService,
        ServicesProvider.of(context).caffeineService,
        ServicesProvider.of(context).hapticsService,
        ServicesProvider.of(context).permissionsService,
        ServicesProvider.of(context).lightSensorService,
        ServicesProvider.of(context).volumeEventsService,
      )..initialize(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => MeteringCommunicationBloc()),
          BlocProvider(
            create: (context) => MeteringBloc(
              MeteringInteractorProvider.of(context),
              VolumeKeysNotifier(ServicesProvider.of(context).volumeEventsService),
              context.read<MeteringCommunicationBloc>(),
              LogbookPhotosProvider.of(context),
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
