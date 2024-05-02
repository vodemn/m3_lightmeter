import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';

class TimerTimeline extends StatelessWidget {
  final double progress;
  final Widget child;

  const TimerTimeline({
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
  static const double radiansQuarterTurn = -pi / 2;
  static const double strokeWidth = Dimens.grid8;

  _TimelinePainter({
    required this.progressColor,
    required this.backgroundColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    late final double radiansProgress = 2 * pi * progress;
    final radius = size.height / 2;
    final timerCenter = Offset(radius, radius);

    final timelineSegmentPath = Path();
    if (progress == 1) {
      timelineSegmentPath.addOval(
        Rect.fromCenter(
          center: timerCenter,
          height: size.height,
          width: size.width,
        ),
      );
    } else {
      timelineSegmentPath
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
        ..lineTo(radius, 0);
    }

    final timelinePath = Path.combine(
      PathOperation.difference,
      timelineSegmentPath,
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
      timelinePath,
      Paint()..color = progressColor,
    );

    canvas.drawPath(
      smoothEdgesPath,
      Paint()..color = progressColor,
    );
  }

  @override
  bool shouldRepaint(_TimelinePainter oldDelegate) => oldDelegate.progress != progress;
}
