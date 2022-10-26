part 'aperture_value.dart';
part 'iso_value.dart';
part 'shutter_speed_value.dart';

enum Stop { full, half, third }

abstract class PhotographyValue<T> {
  final T rawValue;
  final Stop stopType;

  const PhotographyValue(this.rawValue, this.stopType);

  T get value;
}

extension PhotographyValues<T extends PhotographyValue> on List<T> {
  List<T> whereStopType(Stop stopType) {
    switch (stopType) {
      case Stop.full:
        return where((e) => e.stopType == Stop.full).toList();
      case Stop.half:
        return where((e) => e.stopType == Stop.full || e.stopType == Stop.half).toList();
      case Stop.third:
        return where((e) => e.stopType == Stop.full || e.stopType == Stop.third).toList();
    }
  }

  List<T> fullStops() => whereStopType(Stop.full);

  List<T> halfStops() => whereStopType(Stop.half);

  List<T> thirdStops() => whereStopType(Stop.third);
}
