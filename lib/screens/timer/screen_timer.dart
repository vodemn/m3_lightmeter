import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/data/models/exposure_pair.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/timer/bloc_timer.dart';
import 'package:lightmeter/screens/timer/components/text/widget_text_timer.dart';
import 'package:lightmeter/screens/timer/components/timeline/widget_timeline_timer.dart';
import 'package:lightmeter/screens/timer/event_timer.dart';
import 'package:lightmeter/screens/timer/state_timer.dart';

class TimerScreen extends StatefulWidget {
  final ExposurePair exposurePair;
  final Duration duration;

  const TimerScreen({
    required this.exposurePair,
    required this.duration,
    super.key,
  });

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

    timelineController = AnimationController(vsync: this, duration: widget.duration);
    timelineAnimation = Tween<double>(begin: 1, end: 0).animate(timelineController);
    timelineController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.read<TimerBloc>().add(const StopTimerEvent());
      }
    });

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
                        child: TimerText(
                          timeLeft: Duration(milliseconds: (widget.duration.inMilliseconds * value).toInt()),
                          duration: widget.duration,
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
                            onPressed: () {
                              if (timelineAnimation.value == 0) {
                                return;
                              }
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
