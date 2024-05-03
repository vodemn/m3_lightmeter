import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/interactors/metering_interactor.dart';
import 'package:lightmeter/interactors/timer_interactor.dart';
import 'package:lightmeter/providers/services_provider.dart';
import 'package:lightmeter/screens/timer/bloc_timer.dart';
import 'package:lightmeter/screens/timer/screen_timer.dart';

class TimerFlow extends StatelessWidget {
  final ExposurePair exposurePair;
  late final _duration =
      Duration(milliseconds: (exposurePair.shutterSpeed.value * Duration.millisecondsPerSecond).toInt());

  TimerFlow({required this.exposurePair, super.key});

  @override
  Widget build(BuildContext context) {
    return TimerInteractorProvider(
      data: TimerInteractor(
        ServicesProvider.of(context).userPreferencesService,
        ServicesProvider.of(context).hapticsService,
      ),
      child: BlocProvider(
        create: (context) => TimerBloc(
          TimerInteractorProvider.of(context),
          _duration,
        ),
        child: TimerScreen(
          exposurePair: exposurePair,
          duration: _duration,
        ),
      ),
    );
  }
}

class TimerInteractorProvider extends InheritedWidget {
  final TimerInteractor data;

  const TimerInteractorProvider({
    required this.data,
    required super.child,
    super.key,
  });

  static TimerInteractor of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<TimerInteractorProvider>()!.data;
  }

  @override
  bool updateShouldNotify(TimerInteractorProvider oldWidget) => false;
}
