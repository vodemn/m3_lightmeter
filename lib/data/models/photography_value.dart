import 'dart:math';

import 'package:lightmeter/utils/log_2.dart';

enum StopType { full, half, third }

abstract class PhotographyValue<T extends num> {
  final T rawValue;

  const PhotographyValue(this.rawValue);

  T get value => rawValue;

  /// EV difference between `this` and `other`
  double evDifference(PhotographyValue other) => log2(max(1, other.value) / max(1, value));

  String toStringDifference(PhotographyValue other) {
    final ev = log2(max(1, other.value) / max(1, value));
    final buffer = StringBuffer();
    if (ev > 0) {
      buffer.write('+');
    }
    buffer.write(ev.toStringAsFixed(1));
    return buffer.toString();
  }
}

abstract class PhotographyStopValue<T extends num> extends PhotographyValue<T> {
  final StopType stopType;

  const PhotographyStopValue(super.rawValue, this.stopType);
}

extension PhotographyStopValues<T extends PhotographyStopValue> on List<T> {
  List<T> whereStopType(StopType stopType) {
    switch (stopType) {
      case StopType.full:
        return where((e) => e.stopType == StopType.full).toList();
      case StopType.half:
        return where((e) => e.stopType == StopType.full || e.stopType == StopType.half).toList();
      case StopType.third:
        return where((e) => e.stopType == StopType.full || e.stopType == StopType.third).toList();
    }
  }

  List<T> fullStops() => whereStopType(StopType.full);

  List<T> halfStops() => whereStopType(StopType.half);

  List<T> thirdStops() => whereStopType(StopType.third);
}
