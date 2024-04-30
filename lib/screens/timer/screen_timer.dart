import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lightmeter/generated/l10n.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [const CloseButton()],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.fromSize(
                size: Size.square(MediaQuery.sizeOf(context).width - Dimens.paddingL * 4),
                child: _Timer(
                  remainingSeconds: 5,
                  timerLength: 124,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }
}

class _Timer extends StatelessWidget {
  final int remainingSeconds;
  final int timerLength;

  const _Timer({
    required this.remainingSeconds,
    required this.timerLength,
  });

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
        progress: remainingSeconds / timerLength,
      ),
      willChange: true,
      child: Center(
        child: Text(
          parseSeconds(),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
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
    int remainingSeconds = this.remainingSeconds;
    // longer than 1 hours
    if (timerLength >= 3600) {
      final hours = remainingSeconds ~/ 3600;
      buffer.writeAll([addZeroIfNeeded(hours), ':']);
      remainingSeconds -= hours * 3600;
    }
    // longer than 1 minute
    if (timerLength >= 60 || timerLength == 0) {
      final minutes = remainingSeconds ~/ 60;
      buffer.writeAll([addZeroIfNeeded(minutes), ':']);
      remainingSeconds -= minutes * 60;
    }
    // longer than 1 second
    buffer.write(addZeroIfNeeded(remainingSeconds));
    return buffer.toString();
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
