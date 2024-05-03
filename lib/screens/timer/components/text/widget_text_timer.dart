import 'package:flutter/material.dart';

class TimerText extends StatelessWidget {
  final Duration timeLeft;
  final Duration duration;

  const TimerText({
    required this.timeLeft,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          parseSeconds(),
          style: Theme.of(context).textTheme.displayMedium,
        ),
        if (duration.inMinutes < 1)
          Text(
            addZeroIfNeeded(timeLeft.inMilliseconds % 1000, 3),
            style: Theme.of(context).textTheme.displaySmall,
          ),
      ],
    );
  }

  String parseSeconds() {
    final buffer = StringBuffer();
    int remainingMs = timeLeft.inMilliseconds;
    // longer than 1 hours
    if (duration.inSeconds >= Duration.millisecondsPerHour) {
      final hours = remainingMs ~/ Duration.millisecondsPerHour;
      buffer.writeAll([addZeroIfNeeded(hours), ':']);
      remainingMs -= hours * Duration.millisecondsPerHour;
    }
    // longer than 1 minute
    final minutes = remainingMs ~/ Duration.millisecondsPerMinute;
    buffer.writeAll([addZeroIfNeeded(minutes), ':']);
    remainingMs -= minutes * Duration.millisecondsPerMinute;

    // longer than 1 second
    final seconds = remainingMs ~/ Duration.millisecondsPerSecond;
    buffer.writeAll([addZeroIfNeeded(seconds)]);
    remainingMs -= seconds * Duration.millisecondsPerSecond;

    return buffer.toString();
  }

  String addZeroIfNeeded(int value, [int charactersCount = 2]) {
    final zerosCount = charactersCount - value.toString().length;
    return '${"0" * zerosCount}$value';
  }
}
