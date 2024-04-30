import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/screens/timer/bloc_timer.dart';
import 'package:lightmeter/screens/timer/event_timer.dart';
import 'package:lightmeter/screens/timer/state_timer.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

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

    timelineController = AnimationController(vsync: this, duration: Dimens.durationS);
    timelineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(timelineController);

    startStopIconController = AnimationController(vsync: this, duration: Dimens.durationS);
    startStopIconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(startStopIconController);
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
      listenWhen: (previous, current) =>
          previous is TimerStoppedState && current is TimerResumedState ||
          previous is TimerResumedState && current is TimerStoppedState,
      listener: (context, state) => _updateAnimations(state),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Test',
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
                  // SizedBox.fromSize(
                  //   size: Size.square(MediaQuery.sizeOf(context).width - Dimens.paddingL * 4),
                  //   child: BlocBuilder<TimerBloc, TimerState>(
                  //     builder: (context, state) {
                  //       return _Timer(
                  //         timeLeft: state.timeLeft,
                  //         duration: state.duration,
                  //       );
                  //     },
                  //   ),
                  // ),
                  BlocBuilder<TimerBloc, TimerState>(
                    buildWhen: (previous, current) => previous.timeLeft != current.timeLeft,
                    builder: (_, state) => _Timer(
                      timeLeft: state.timeLeft,
                      duration: state.duration,
                    ),
                  ),
                  const Spacer(),
                  BlocBuilder<TimerBloc, TimerState>(
                    builder: (_, state) => FloatingActionButton(
                      onPressed: () {
                        context.read<TimerBloc>().add(
                              state is TimerStoppedState ? const StartTimerEvent() : const StopTimerEvent(),
                            );
                      },
                      child: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: startStopIconAnimation,
                      ),
                    ),
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
      case TimerResumedState():
        startStopIconController.forward();
      case TimerStoppedState():
        startStopIconController.reverse();
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
    return Text(
      parseSeconds(),
      style: Theme.of(context).textTheme.headlineLarge,
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

class _TimerTimeline extends StatelessWidget {
  final double progress;
  final Widget child;

  const _TimerTimeline({
    required this.progress,
    required this.child,
  }) : assert(progress >= 0 && progress <= 1);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TimelinePainter(
        backgroundColor: ElevationOverlay.applySurfaceTint(
          Theme.of(context).cardTheme.color!,
          Theme.of(context).cardTheme.surfaceTintColor,
          Theme.of(context).cardTheme.elevation!,
        ),
        progressColor: Theme.of(context).colorScheme.primary,
        progress: progress,
      ),
      willChange: true,
      child: Center(child: child),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final Color progressColor;
  final Color backgroundColor;
  final double progress;

  late final double timelineEdgeRadius = strokeWidth / 2;
  late final double radiansProgress = 2 * pi * progress;
  static const double radiansQuarterTurn = -pi / 2;
  static const double strokeWidth = Dimens.grid8;

  _TimelinePainter({
    required this.progressColor,
    required this.backgroundColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.height / 2;
    final timerCenter = Offset(radius, radius);
    final timelineSegmentPath = Path.combine(
      PathOperation.difference,
      Path()
        ..arcTo(
          Rect.fromCenter(
            center: timerCenter,
            height: size.height,
            width: size.width,
          ),
          radiansQuarterTurn,
          radiansProgress,
          false,
        )
        ..lineTo(radius, radius)
        ..lineTo(radius, 0),
      Path()
        ..addOval(
          Rect.fromCircle(
            center: timerCenter,
            radius: radius - strokeWidth,
          ),
        ),
    );

    final smoothEdgesPath = Path.combine(
      PathOperation.union,
      Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(radius, timelineEdgeRadius),
            radius: timelineEdgeRadius,
          ),
        ),
      Path()
        ..addOval(
          Rect.fromCircle(
            center: Offset(
              (radius - timelineEdgeRadius) * cos(radiansProgress + radiansQuarterTurn) + radius,
              (radius - timelineEdgeRadius) * sin(radiansProgress + radiansQuarterTurn) + radius,
            ),
            radius: timelineEdgeRadius,
          ),
        ),
    );

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()
          ..addOval(
            Rect.fromCircle(
              center: timerCenter,
              radius: radius,
            ),
          ),
        Path()
          ..addOval(
            Rect.fromCircle(
              center: timerCenter,
              radius: radius - strokeWidth,
            ),
          ),
      ),
      Paint()..color = backgroundColor,
    );

    canvas.drawPath(
      Path.combine(
        PathOperation.union,
        timelineSegmentPath,
        smoothEdgesPath,
      ),
      Paint()..color = progressColor,
    );
  }

  @override
  bool shouldRepaint(_TimelinePainter oldDelegate) => oldDelegate.progress != progress;
}
