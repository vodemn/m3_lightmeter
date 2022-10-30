part 'aperture_value.dart';
part 'iso_value.dart';
part 'shutter_speed_value.dart';

enum StopType { full, half, third }

abstract class PhotographyValue<T> {
  final T rawValue;
  final StopType stopType;

  const PhotographyValue(this.rawValue, this.stopType);

  T get value;
}

extension PhotographyValues<T extends PhotographyValue> on List<T> {
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
