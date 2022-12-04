enum StopType { full, half, third }

abstract class PhotographyValue<T> {
  final T rawValue;

  const PhotographyValue(this.rawValue);

  T get value => rawValue;
}

abstract class PhotographyStopValue<T> extends PhotographyValue<T> {
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
