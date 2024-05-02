import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/timer/bloc_timer.dart';
import 'package:lightmeter/screens/timer/components/timeline/widget_timeline_timer.dart';
import 'package:lightmeter/screens/timer/event_timer.dart';
import 'package:lightmeter/screens/timer/state_timer.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

class TimerScreen extends StatefulWidget {
  final ExposurePair exposurePair;

  const TimerScreen({required this.exposurePair, super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with TickerProviderStateMixin {
  late AnimationController timelineController;
  late Animation<double> timelineAnimation;
  late AnimationController startStopIconController;
  late Animation<double> startStopIconAnimation;

  @override
  void initState() {
    super.initState();

    timelineController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.exposurePair.shutterSpeed.value.toInt()),
    );
    timelineAnimation = Tween<double>(begin: 1, end: 0).animate(timelineController);

    startStopIconController = AnimationController(vsync: this, duration: Dimens.durationS);
    startStopIconAnimation = Tween<double>(begin: 0, end: 1).animate(startStopIconController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<TimerBloc>().add(const StartTimerEvent());
  }

  @override
  void dispose() {
    timelineController.dispose();
    startStopIconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO (@vodemn): split build in timer/components folder
    return BlocListener<TimerBloc, TimerState>(
      listenWhen: (previous, current) => previous.runtimeType != current.runtimeType,
      listener: (context, state) => _updateAnimations(state),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          title: Text(
            widget.exposurePair.toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: Dimens.grid24,
            ),
          ),
          actions: [if (Navigator.of(context).canPop()) const CloseButton()],
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.paddingL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  SizedBox.fromSize(
                    size: Size.square(MediaQuery.sizeOf(context).width - Dimens.paddingL * 4),
                    child: ValueListenableBuilder(
                      valueListenable: timelineAnimation,
                      builder: (_, value, child) => TimerTimeline(
                        progress: value,
                        child: child!,
                      ),
                      child: BlocBuilder<TimerBloc, TimerState>(
                        buildWhen: (previous, current) => previous.timeLeft != current.timeLeft,
                        builder: (_, state) => _Timer(
                          timeLeft: state.timeLeft,
                          duration: state.duration,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              context.read<TimerBloc>().add(const ResetTimerEvent());
                            },
                            icon: const Icon(Icons.restore),
                          ),
                        ),
                      ),
                      SizedBox.fromSize(
                        size: const Size.square(Dimens.grid72),
                        child: BlocBuilder<TimerBloc, TimerState>(
                          builder: (_, state) => FloatingActionButton(
                            shape: state is TimerResumedState ? null : const CircleBorder(),
                            onPressed: state.timeLeft.inSeconds == 0
                                ? null
                                : () {
                                    final event =
                                        state is TimerStoppedState ? const StartTimerEvent() : const StopTimerEvent();
                                    context.read<TimerBloc>().add(event);
                                  },
                            child: AnimatedIcon(
                              icon: AnimatedIcons.play_pause,
                              progress: startStopIconAnimation,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateAnimations(TimerState state) {
    switch (state) {
      case TimerResetState():
        startStopIconController.reverse();
        timelineController.stop();
        timelineController.animateTo(0, duration: Dimens.durationS);
      case TimerResumedState():
        startStopIconController.forward();
        timelineController.forward();
      case TimerStoppedState():
        startStopIconController.reverse();
        timelineController.stop();
    }
  }
}

class _Timer extends StatelessWidget {
  final Duration timeLeft;
  final Duration duration;

  const _Timer({
    required this.timeLeft,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          parseSeconds(),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        // Text(
        //   '${timeLeft.inMilliseconds % 1000}'.substring(0,2),
        //   style: Theme.of(context).textTheme.headlineSmall,
        // ),
      ],
    );
  }

  String parseSeconds() {
    String addZeroIfNeeded(int value) {
      if (value == 0) {
        return '00';
      } else if (value < 10) {
        return '0$value';
      } else {
        return '$value';
      }
    }

    final buffer = StringBuffer();
    int remainingSeconds = timeLeft.inSeconds;
    // longer than 1 hours
    if (duration.inSeconds >= 3600) {
      final hours = remainingSeconds ~/ 3600;
      buffer.writeAll([addZeroIfNeeded(hours), ':']);
      remainingSeconds -= hours * 3600;
    }
    // longer than 1 minute
    if (duration.inSeconds >= 60 || duration.inSeconds == 0) {
      final minutes = remainingSeconds ~/ 60;
      buffer.writeAll([addZeroIfNeeded(minutes), ':']);
      remainingSeconds -= minutes * 60;
    }
    // longer than 1 second
    buffer.write(addZeroIfNeeded(remainingSeconds));
    return buffer.toString();
  }
}
