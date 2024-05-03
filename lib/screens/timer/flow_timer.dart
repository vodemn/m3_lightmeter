import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/timer/bloc_timer.dart';
import 'package:lightmeter/screens/timer/screen_timer.dart';

class TimerFlow extends StatelessWidget {
  final ExposurePair exposurePair;
  late final _duration =
      Duration(milliseconds: (exposurePair.shutterSpeed.value * Duration.millisecondsPerSecond).toInt());

  TimerFlow({required this.exposurePair, super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IconButtonTheme(
      data: IconButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(scheme.surface),
          elevation: const MaterialStatePropertyAll(4),
          iconColor: MaterialStatePropertyAll(scheme.onSurface),
          shadowColor: const MaterialStatePropertyAll(Colors.transparent),
          surfaceTintColor: MaterialStatePropertyAll(scheme.surfaceTint),
          fixedSize: const MaterialStatePropertyAll(Size(Dimens.grid48, Dimens.grid48)),
        ),
      ),
      child: MeteringInteractorProvider(
        data: MeteringInteractor(
          ServicesProvider.of(context).userPreferencesService,
          ServicesProvider.of(context).caffeineService,
          ServicesProvider.of(context).hapticsService,
          ServicesProvider.of(context).permissionsService,
          ServicesProvider.of(context).lightSensorService,
          ServicesProvider.of(context).volumeEventsService,
        )..initialize(),
        child: BlocProvider(
          create: (context) => TimerBloc(
            MeteringInteractorProvider.of(context),
            _duration,
          ),
          child: TimerScreen(
            exposurePair: exposurePair,
            duration: _duration,
          ),
        ),
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
